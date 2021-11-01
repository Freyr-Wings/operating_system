volatile unsigned int * const UART0DR = (unsigned int *) 0x09000000;  // https://github.com/qemu/qemu/blob/master/hw/arm/virt.c
 
void print_uart0(const char *s) {
    while(*s != '\0') { 		/* Loop until end of string */
         *UART0DR = (unsigned int)(*s); /* Transmit char */
          s++;			        /* Next char */
    }
}
 
void c_entry() {
     print_uart0("Hello world!\n");
}