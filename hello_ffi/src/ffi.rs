use hello_core::{HelloInstruction, HelloState};
use nssa_core::account::{Account, AccountId, AccountWithMetadata, Data};
use std::ffi::{CStr, CString};
use std::os::raw::c_char;

/// Submit a StoreName transaction. Expects JSON: {"name": "..."}
/// Returns JSON with the greeting or an error.
#[no_mangle]
pub extern "C" fn hello_store_name(input_json: *const c_char) -> *mut c_char {
    let result = std::panic::catch_unwind(|| {
        let input = unsafe { CStr::from_ptr(input_json) }
            .to_str()
            .unwrap_or("{}");

        let parsed: serde_json::Value = match serde_json::from_str(input) {
            Ok(v) => v,
            Err(e) => return json_error(&format!("Invalid JSON: {}", e)),
        };

        let name = match parsed.get("name").and_then(|v| v.as_str()) {
            Some(n) => n.to_string(),
            None => return json_error("Missing 'name' field"),
        };

        let authority_id = parsed
            .get("authority")
            .and_then(|v| v.as_str())
            .map(|s| account_id_from_str(s))
            .unwrap_or_else(|| AccountId::new([1u8; 32]));

        let state_id = AccountId::new([2u8; 32]);

        // Load existing state if provided
        let existing_data: Data = parsed
            .get("existing_state")
            .and_then(|v| v.as_str())
            .map(|s| s.as_bytes().to_vec().try_into().unwrap())
            .unwrap_or_default();

        let accounts = vec![
            AccountWithMetadata {
                account: Account {
                    data: existing_data,
                    ..Account::default()
                },
                is_authorized: false,
                account_id: state_id,
            },
            AccountWithMetadata {
                account: Account::default(),
                is_authorized: true,
                account_id: authority_id,
            },
        ];

        let instruction = HelloInstruction::StoreName { name: name.clone() };
        let instruction_data = serde_json::to_vec(&instruction).unwrap();

        let results = hello_program::process(&instruction_data, &accounts);

        if let Some(result) = results.first() {
            let account = result.account();
            let state: HelloState = serde_json::from_slice(&account.data).unwrap();
            let state_data_str = String::from_utf8_lossy(&account.data).to_string();
            serde_json::to_string(&serde_json::json!({
                "success": true,
                "greeting": state.greeting(),
                "name": state.name,
                "state_data": state_data_str,
            }))
            .unwrap()
        } else {
            json_error("No account state returned")
        }
    });

    let response = match result {
        Ok(s) => s,
        Err(_) => json_error("Internal panic in hello_store_name"),
    };

    CString::new(response).unwrap().into_raw()
}

/// Read stored data and return the greeting. Expects JSON: {"state_data": "..."}
/// Returns JSON: {"greeting": "Hello <name>!", "name": "..."}
#[no_mangle]
pub extern "C" fn hello_read(input_json: *const c_char) -> *mut c_char {
    let result = std::panic::catch_unwind(|| {
        let input = unsafe { CStr::from_ptr(input_json) }
            .to_str()
            .unwrap_or("{}");

        let parsed: serde_json::Value = match serde_json::from_str(input) {
            Ok(v) => v,
            Err(e) => return json_error(&format!("Invalid JSON: {}", e)),
        };

        let state_data = match parsed.get("state_data").and_then(|v| v.as_str()) {
            Some(s) => s,
            None => return json_error("Missing 'state_data' field"),
        };

        let state: HelloState = match serde_json::from_str(state_data) {
            Ok(s) => s,
            Err(e) => return json_error(&format!("Invalid state data: {}", e)),
        };

        serde_json::to_string(&serde_json::json!({
            "success": true,
            "greeting": state.greeting(),
            "name": state.name,
        }))
        .unwrap()
    });

    let response = match result {
        Ok(s) => s,
        Err(_) => json_error("Internal panic in hello_read"),
    };

    CString::new(response).unwrap().into_raw()
}

/// Return the IDL (Interface Description Language) for this program.
#[no_mangle]
pub extern "C" fn hello_get_idl() -> *mut c_char {
    let idl = serde_json::json!({
        "name": "HelloWorld",
        "version": "0.1.0",
        "instructions": [
            {
                "name": "StoreName",
                "fields": [
                    {
                        "name": "name",
                        "type": "string",
                        "required": true,
                        "description": "The name to store and greet"
                    }
                ]
            }
        ],
        "accounts": [
            {
                "name": "HelloState",
                "fields": [
                    {"name": "owner", "type": "[u8; 32]"},
                    {"name": "name", "type": "string"}
                ]
            }
        ]
    });

    CString::new(serde_json::to_string(&idl).unwrap())
        .unwrap()
        .into_raw()
}

/// Return module version.
#[no_mangle]
pub extern "C" fn hello_version() -> *mut c_char {
    CString::new("0.1.0").unwrap().into_raw()
}

/// Free a string allocated by this library.
#[no_mangle]
pub extern "C" fn hello_free_string(s: *mut c_char) {
    if !s.is_null() {
        unsafe {
            let _ = CString::from_raw(s);
        }
    }
}

fn json_error(msg: &str) -> String {
    serde_json::to_string(&serde_json::json!({
        "success": false,
        "error": msg
    }))
    .unwrap()
}

fn account_id_from_str(s: &str) -> AccountId {
    let bytes = s.as_bytes();
    let mut id = [0u8; 32];
    let len = bytes.len().min(32);
    id[..len].copy_from_slice(&bytes[..len]);
    AccountId::new(id)
}
