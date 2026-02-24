#ifndef HELLO_PROGRAM_H
#define HELLO_PROGRAM_H

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Submit a StoreName transaction.
 * Input JSON: {"name": "..."}
 * Returns JSON with greeting or error.
 */
char* hello_store_name(const char* input_json);

/**
 * Read stored data and return the greeting.
 * Input JSON: {"state_data": "..."}
 * Returns JSON: {"greeting": "Hello <name>!", "name": "..."}
 */
char* hello_read(const char* input_json);

/**
 * Return the IDL for this program.
 */
char* hello_get_idl(void);

/**
 * Return module version string.
 */
char* hello_version(void);

/**
 * Free a string allocated by this library.
 */
void hello_free_string(char* s);

#ifdef __cplusplus
}
#endif

#endif /* HELLO_PROGRAM_H */
