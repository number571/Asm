extern int input_number();
extern void print_number(int x);

int main(void) {
	int x = input_number();
	print_number(x + 25);
	return 0;
}
