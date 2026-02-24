use nssa_core::account::AccountId;
use nssa_core::program::PdaSeed;
use serde::{Deserialize, Serialize};

/// Instructions supported by the Hello World program.
#[derive(Serialize, Deserialize, Debug, Clone)]
pub enum HelloInstruction {
    /// Store a name in a PDA account.
    StoreName { name: String },
}

/// State stored in the PDA account.
#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct HelloState {
    pub owner: [u8; 32],
    pub name: String,
}

impl HelloState {
    /// Returns the greeting string.
    pub fn greeting(&self) -> String {
        format!("Hello {}!", self.name)
    }
}

/// Derive PDA seeds for a given owner.
pub fn hello_pda_seeds(owner: &AccountId) -> (PdaSeed, PdaSeed) {
    let mut tag = [0u8; 32];
    let hello = b"hello";
    tag[..hello.len()].copy_from_slice(hello);

    (PdaSeed::new(tag), PdaSeed::new(*owner.value()))
}
