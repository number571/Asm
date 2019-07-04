extern int input_number();
extern int factorial(int x);
extern void print_number(int x);

int main(void) {
    int x = input_number();
    print_number(factorial(x));
    return 0;
}
