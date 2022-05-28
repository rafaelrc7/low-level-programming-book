void exit(long code);
long string_length(const char *str);
void print_string(const char *str);
void print_char(char chr);
void print_newline();
void print_uint(unsigned long ui);
void print_int(long i);
char *read_word(char *buff, long int size);
unsigned long parse_uint(char *str);
long parse_int(char *str);
long string_equals(char *st1, char *str2);
char *string_copy(const char *str, char *buff, long buff_size);

int main(void) {
	char *str = "hello, world!";
	char *ptr;
	char buff[256];


	print_int(-12345);
	print_newline();
	print_int(12345);
	print_newline();
	print_int(-1);
	print_newline();

}

