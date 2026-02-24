#![no_main]
risc0_zkvm::guest::entry!(main);

use nssa_core::account::AccountWithMetadata;

fn main() {
    let instruction_data: Vec<u8> = risc0_zkvm::guest::env::read();
    let accounts: Vec<AccountWithMetadata> = risc0_zkvm::guest::env::read();
    let results = hello_program::process(&instruction_data, &accounts);
    risc0_zkvm::guest::env::commit(&results);
}
