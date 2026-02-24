#ifndef HELLO_PROGRAM_H
#define HELLO_PROGRAM_H

#ifdef __cplusplus
extern "C" {
#endif

char* hello_store_name(const char* input_json);
char* hello_read(const char* input_json);
char* hello_get_idl(void);
char* hello_version(void);
void hello_free_string(char* s);

#ifdef __cplusplus
}
#endif

#endif /* HELLO_PROGRAM_H */
