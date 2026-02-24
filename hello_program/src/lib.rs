use hello_core::{HelloInstruction, HelloState};
use nssa_core::account::AccountWithMetadata;
use nssa_core::program::AccountPostState;

/// Process a Hello World instruction.
///
/// Account layout:
/// - accounts[0]: State PDA (program-owned)
/// - accounts[1]: Caller/authority (authorized)
pub fn process(
    instruction_data: &[u8],
    accounts: &[AccountWithMetadata],
) -> Vec<AccountPostState> {
    let instruction: HelloInstruction =
        serde_json::from_slice(instruction_data).expect("Failed to deserialize instruction");

    match instruction {
        HelloInstruction::StoreName { name } => {
            assert!(accounts.len() >= 2, "Expected at least 2 accounts");

            let state_account = &accounts[0];
            let authority = &accounts[1];

            assert!(authority.is_authorized, "Authority must be authorized");

            let mut state: HelloState = if state_account.account.data.is_empty() {
                HelloState::default()
            } else {
                serde_json::from_slice(&state_account.account.data)
                    .expect("Failed to deserialize state")
            };

            state.owner = *authority.account_id.value();
            state.name = name;

            let serialized =
                serde_json::to_vec(&state).expect("Failed to serialize state");

            let mut account = state_account.account.clone();
            account.data = serialized.try_into().expect("State data too large");

            vec![AccountPostState::new_claimed(account)]
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use nssa_core::account::{Account, AccountId, AccountWithMetadata};

    #[test]
    fn test_store_and_greet() {
        let authority_id = AccountId::new([1u8; 32]);

        let accounts = vec![
            AccountWithMetadata {
                account: Account::default(),
                is_authorized: false,
                account_id: AccountId::new([2u8; 32]),
            },
            AccountWithMetadata {
                account: Account::default(),
                is_authorized: true,
                account_id: authority_id,
            },
        ];

        let instruction = HelloInstruction::StoreName {
            name: "World".to_string(),
        };
        let instruction_data = serde_json::to_vec(&instruction).unwrap();

        let results = process(&instruction_data, &accounts);
        assert_eq!(results.len(), 1);

        let result_account = results[0].account();
        let state: HelloState = serde_json::from_slice(&result_account.data).unwrap();
        assert_eq!(state.name, "World");
        assert_eq!(state.owner, [1u8; 32]);
        assert_eq!(state.greeting(), "Hello World!");
    }
}
