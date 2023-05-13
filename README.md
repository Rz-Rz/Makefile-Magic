# Makefile-Magic
### Introduction
This Makefile compiles a C project with a main program and a bonus program. It also includes various useful rules for building, debugging, profiling and cleaning the project.
I built this project to help me quickstart a makefile on any project in C/C++. I figured out that it could be of help to some people so i decided to share it here. 

### Variables
**NAME**: Name of the main executable  
**BONUS_NAME**: Name of the bonus executable  
**SRCS_DIR**, **BONUS_DIR**, **OBJS_DIR**, **BONUS_OBJS_DIR**: Directories for source and object files  
**SRCS**, **BONUS**: Lists of source files for the main and bonus programs  
**OBJS**, **BONUS_OBJS**: Lists of object files for the main and bonus programs  
**CC**: The C compiler to use  
**CFLAGS**: Compilation flags  
**DEBUG**, **FSANITIZE_FLAGS**, **FAST_FLAGS**: Additional flags for debugging, sanitizing, and optimizing the program  
**LIB**: Libraries to link with  
**HEADERS**, **BONUS_HEADERS**: Header files for the main and bonus programs  
### Main Rules
**all**: (default rule) Builds both the main and bonus executables  
**$(NAME)**: Builds the main executable  
**$(BONUS_NAME)**, bonus: Builds the bonus executable  
**clean**: Removes all object files and cleans the library  
**fclean**: Removes all executables  
**re**: Forces a complete rebuild  
### Debugging and Profiling Rules
**valgrind**, **helgrind**, **drd**, **callgrind**: Runs the respective tools on the main executable  
**valgrind_bonus**, **helgrind_bonus**, **drd_bonus**, **callgrind_bonus**: Runs the respective tools on the bonus executable  
**scan-build**, **scan-build_bonus**: Runs scan-build on the main or bonus program  
**debug**: Builds the program with debugging flags  
**fsanitize**, **fsanitize_bonus**: Builds the program with sanitizing flags  
**fast**, **fast_bonus**: Builds the program with optimization flags  
### Other Rules
**$(OBJS_DIR)**, **$(BONUS_OBJS_DIR)**: Rules to create the directories for object files  
**${OBJS_DIR}/%.o**,** ${BONUS_OBJS_DIR}/%.o**: Pattern rules to build object files from source files  
**${LIB}**: Rule to build the library  
**help**: Displays a help message  
**.PHONY**: Phony rule to avoid conflicts with file names  

# How to run : 
The following is for all classic make rules : all, clean, fclean, re.
```bash
make all
```

When running tools you can use the ARGS env var to pass parameter to the executable :
```bash
make valgrind ARGS="/dev/stdin cat ls /dev/stdout"
```
Otherwise just run
```bash
make debug
your-tool ./exe
```

### Nota Bene:
- This Makefile also includes some examples and comments for extending and modifying it.
- If you are a 42 student: Implicit declaration of srcs files or includes files is forbidden by norminette ! (Ex: SRCS	= $(shell find srcs/*.c -exec basename \ {} \;))
- If you are a 42 student: Using wildcard is forbidden by the norminette ! (Ex : SRCS := $(wildcard srcs/*.c srcs/*/*.c))

# Useful flags and tools
### Debug Flag
The -g option in gcc is used to enable the generation of debugging information. This information is used by debuggers such as gdb to help you understand what is going on inside your program when you debug it.

The -g option alone generates the default level of debugging information. However, gcc allows you to specify a level of debugging information using -glevel.

The levels are:

**-g0**: Produces no debugging information.  
**-g1**: Produces minimal information, enough for making backtraces in parts of the program that you don't plan to debug. This includes descriptions of functions and external variables, and line number tables, but no information about local variables.  
**-g2**: (This is the default when -g is specified.) Includes extra information, such as all the macro definitions present in the program. Some debuggers support macro expansion when you use -g2.  
**-g3**: Includes everything specified by -g2, as well as additional information such as macro definitions, to make debugging even more informative.
So, -g3 includes more debugging information than -g, making it easier to debug your program in detail, but it will also make your binaries larger.
Compiling with -g3 and using valgrind provides the best debugging result. You will be able to trace the error down precisely at the line number.  

### Optimization flags
The flags you have mentioned are typically used to optimize your C/C++ code during compilation with GCC:

**-Ofast**: This enables all -O3 optimizations (which includes -O2 and -O1). It also enables optimizations that are not valid for all standard-compliant programs. It turns on -ffast-math which is a set of optimizations for numerical code that may violate strict compliance with the C and C++ standards, but usually gives correct results.  

**-flto**: This stands for "Link Time Optimization". With LTO, GCC can optimize across the entire program, with visibility to all code at the same time. This can enable more aggressive optimizations, but can also increase compile time and use more memory during compilation.  
 
**-march=native**: This tells GCC to generate code that is optimized for the host computer where the compile is happening. GCC will detect the specific type of CPU and its features (like additional instruction set extensions) and tune the generated code to make best use of them. This can make your program significantly faster on your machine, but the resulting binary may not work on a different machine with a different or older CPU.  

Please note that, while these flags can make your program faster, they are not a magic bullet. The actual impact on performance can vary widely depending on the specific code. It's also important to note that these flags make the build less portable, especially -march=native which may generate a binary that doesn't work on other machines. They can also make debugging more difficult because of the additional optimizations. As always with optimizations, you should measure the performance before and after applying these flags to see if they help for your specific case. Never use valgrind with an optimization supperior to -O1, otherwise you may encounter false positive, false negative, wrong line numbers for errors etc. Even -O1 can cause these issue although it's quite rare.  

### Sanitize the Compilation with ASAN and UBSAN

**-fsanitize=address** and **-fsanitize=undefined** serve different purposes and catch different types of bugs. They can be used together but neither includes the other.

**-fsanitize=address** is used to detect memory issues such as:

- Out-of-bounds accesses to heap, stack and globals
- Use-after-free and use-after-return
- Double-free, invalid free
- Memory leaks

**-fsanitize=undefined** is used to catch undefined behavior issues such as:

- Integer divide by zero
- Integer overflow
- Null pointer dereference
- Invalid shift operations
etc.
In other words, **-fsanitize=address** is more about memory safety, while **-fsanitize=undefined** is about catching tricky undefined behaviors that can lead to hard-to-debug issues.

# Tools
### Valgrind
Valgrind is a powerful tool for memory debugging, memory leak detection, and profiling. It can be used to find problems that lurk in even the most complex software, including use of uninitialized memory, improper freeing of memory, writing past the end of arrays, and more. To use Valgrind, simply prefix your usual run command with valgrind. For example, if your program is ./program, use valgrind ./program. Valgrind will run your program and report any memory leaks or errors it detects.
The Makefile runs Valgrind with the following option: 

**--leak-check=full**: This option turns on the detailed memory leak detector. When your program exits, Valgrind will search for blocks of memory it can no longer reach (i.e., leaks). With full, it provides more information about each individual lost block, including the exact chain of pointers that leads to the lost block (if possible), the size of the lost block, and more.

**--show-leak-kinds=all**: This option allows you to specify the kinds of leaks that should be reported. The all option means it will report all types of memory leaks, including definite, possible, reachable and indirect leaks.

**--track-fds=yes**: This option enables tracking of file descriptors. When enabled, Valgrind will track open file descriptors and will report those that are still open at exit. This can be useful for finding file descriptors that were accidentally left open.

**--trace-children=yes**: This option tells Valgrind to also run its analysis on child processes created by the main process using the fork or exec system calls. This is useful when you want to check multi-process applications or if your program spawns other programs as part of its operation. If you are a 42 student, this is very useful to check for errors in forked process (Pipex, Minishell, Philosophers Bonus).

### DRD (Data Race Detector)
DRD is a thread error detector. It can detect and report on data races and deadlocks in multithreaded C and C++ programs. Data races occur when two threads access the same memory location concurrently, and at least one of the accesses is a write. Deadlocks are situations where two or more threads cannot proceed because each is waiting for the other to release a resource. Using DRD can help find these complex errors. To use DRD, use valgrind --tool=drd ./program.

### Callgrind
Callgrind is a profiling tool that records the call history among functions in a program's call graph. Callgrind collects data such as the number of instructions executed, their locations, and the relationships between these functions. You can then use the collected data to find bottlenecks in your code and improve performance. To use Callgrind, use valgrind --tool=callgrind ./program.

### Scan-build
Scan-build is a tool for static code analysis. It intercepts calls to the compiler and runs the Clang static analyzer on the code. The static analyzer can find bugs such as use-after-free, double-free, memory leaks, null pointer dereferences, and more. To use scan-build, prefix your build command with scan-build. For example, if you build your program with make, use scan-build make.

### Helgrind
Helgrind is a Valgrind tool for detecting synchronization errors in C, C++ and Fortran programs that use the POSIX pthreads threading primitives. It can detect potential race conditions where threads are accessing shared data without appropriate locking. To use Helgrind, use valgrind --tool=helgrind ./program.

All of these tools are powerful additions to your software development toolkit. They can help you catch bugs early, understand how your code is performing, and ensure that your software is robust and efficient. When you encounter complex bugs, these tools can often help you find the root cause more quickly and accurately than manual debugging.
