### Process Virtual Machine (PVM)
  - is a normal application running in an OS
  - provides an environment that allows programs implemented on it can be executed on any platform without awareness of the underlying hardware

### VM commands:
  - command
  - command arg
  - command arg1 arg2

### 9 stack-oriented arithmetic & logical commands:
  - add
  - sub
  - neg
  - eq
  - gt
  - lt
  - and
  - or
  - not

### 2 memory access commands:
  - push SEGMENT INDEX => append value of SEGMENT[INDEX] onto the stack
  - pop SEGMENT INDEX => remove top stack value and store it in SEGMENT[INDEX]

### 8 segments in memory access:
  - argument
  - local
  - static
  - constant
  - this
  - that
  - pointer
  - temp

### Jack-VM-Hack platform
  - each jack file will be translated into a vm file. Eg: example.jack ==> example.vm
  - each method of a jack class will be translated into a vm function. Eg: method bar in class Foo ==> function Foo.bar
  - VM translator works by:
    - 1st: emulating virtual memory segments of each function, file and stack
    - 2nd: effect the vm commands

### Implementation
#### VM mapping
  - vm translator translates each vm command into Hack assembly code
#### Program Structure
  * Parser Module
    - command types:
      - C_ARITHMETIC
      - C_PUSH
      - C_POP
      - C_LABEL
      - C_GOTO
      - C_IF
      - C_FUNCTION
      - C_RETURN
      - C_CALL
  * CodeWriter Module
  * Main Program
