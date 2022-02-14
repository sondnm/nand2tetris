### Terms
- built-in commands
- subroutines: programmer defined operations (subroutines, functions, procedures, methods)
- frame: subroutine's local variables, arguments, its working stack and other memory segments
- stack: global stack - the memory area containing current working subroutine and all the subroutines waiting for it to return. The working stack of the current subroutine is located at the very tip of the global stack.

### Program Flow Commands
- `label <LABEL>`: label the current location
- `goto <LABEL>`: unconditionally continue from location marked by given label
- `if-goto <LABEL>`: conditionally continue from location marked by given label

### Function Calling Commands
- `function f n`: function named `f` with `n` local variables
- `call f m`: call function `f` with m arguments already pushed to the stack by the caller
- `return`: return to the calling function
