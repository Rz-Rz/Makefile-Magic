# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kdhrif <kdhrif@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/11/29 14:25:53 by kdhrif            #+#    #+#              #
#    Updated: 2023/05/13 15:31:46 by kdhrif           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Name of the main executable
NAME     		=

# Name of the bonus executable
BONUS_NAME 		=

# Directory containing source files
SRCS_DIR 		= srcs

# Directory containing bonus source files
BONUS_DIR 		= bonus

# Directory for object files
OBJS_DIR 		= objs

# Directory for bonus object files
BONUS_OBJS_DIR 	= bonus_objs

# Source files
SRCS			= $(shell find srcs/*.c -exec basename \ {} \;)
#Example to add a path to look for source files : 
# SRCS_EXEC		:=	$(shell find srcs/exec/*.c -exec basename \ {} \;)

# Bonus source files
BONUS			= $(shell find bonus/*.c -exec basename \ {} \;)

# Object files
OBJS     		= ${patsubst %.c,${OBJS_DIR}/%.o,${SRCS}}
# Example to add a rule to build object files :
# OBJS_EXEC 	= ${patsubst %.c,${OBJS_DIR}/%.o,${SRCS_EXEC}}
# Another way to do it is by using wildcard. This method creates less variables :
# SRCS         := $(wildcard srcs/*.c srcs/*/*.c)
# OBJS         := $(patsubst srcs/%.c, $(OBJS_DIR)/%.o, $(SRCS))

# Bonus object files
BONUS_OBJS 		= ${patsubst %.c,${BONUS_OBJS_DIR}/%.o,${BONUS}}

# Compiler to use
CC       		= gcc

# Compilation flags
CFLAGS   		= -Wall -Wextra -Werror

# Debug flags
DEBUG           = -g3

# Sanitize flags
FSANITIZE_FLAGS = -fsanitize=address -fsanitize=undefined

# Flags for fast execution
FAST_FLAGS      = -Ofast -flto -march=native

# Library files
LIB      		= #libft/libft.a

# Header files
HEADERS  		= #includes/pipex.h
# Example to add a path to look for header files when you have many header files :
# INCS	=\
./utils/str\
./utils/lst/include\
./utils/is_charset\
./utils\
./utils/file\
./utils/memory\
./utils/int_array\
./utils/get_next_line\
./parsing/\
.\
./mlx_linux\
./mlx_linux\
./mlx_utils/color\
./mlx_utils/vec2\
./mlx_utils/texture\
./mlx_utils/event\
./mlx_utils/event/window\
./mlx_utils/event/keyboard\
./mlx_utils/event/mouse\
./mlx_utils/line\
./mlx_utils/pixel\
./mlx_utils/screen\
./mlx_utils\
./mlx_utils/image\
# Look at the object files rule to see how to add a path to look for header files during compilation

# Bonus header files
BONUS_HEADERS 	= #includes/pipex_bonus.h

# Default rule (first one), build the main and bonus executables
all: $(NAME) $(BONUS_NAME)

# Create object files directory and compile
$(OBJS_DIR):
	@mkdir -p $(OBJS_DIR)
	@echo "\033[33mcompiling ${NAME}..."
	@echo "SRCS = ${SRCS}"
	@echo "OBJS = ${OBJS}"

# Create bonus object files directory and compile
$(BONUS_OBJS_DIR):
	@mkdir -p $(BONUS_OBJS_DIR)
	@echo "\033[33mcompiling ${NAME}..."
	@echo "SRCS = ${BONUS}"
	@echo "OBJS = ${BONUS_OBJS}"

# Rule for creating object files
${OBJS_DIR}/%.o: ${SRCS_DIR}/%.c
	@${CC} ${CFLAGS} -c $< -o $@

# Rule for creating the library
${LIB} :
	@make -C libft

# Rule for building the main executable
${NAME}: $(LIB) $(OBJS_DIR) $(OBJS) ${HEADERS} #${OBJS_EXEC}
	$(CC) $(CFLAGS) $(OBJS) ${LIB} -o $(NAME) #${OBJS_EXEC} You want also the objects from the added subdirectory !
	@echo "\033[32m$ ${NAME} compiled !"

# Example: Rule for building object files in a subdirectory
# ${OBJS_DIR}/%.o: srcs/exec/%.c
# 	@${CC} ${CFLAGS} -I. -c $< -o $@

# Rule for building bonus object files
${BONUS_OBJS_DIR}/%.o: ${BONUS_DIR}/%.c
	# $(addprefix -I , $(INCS)) # You get this afterward : -I dir1 -I dir2 -I dir3
	@${CC} ${CFLAGS} -c $< -o $@


# Rule for building the bonus executable
${BONUS_NAME}: $(LIB) $(BONUS_OBJS_DIR) $(BONUS_OBJS) ${BONUS_HEADERS}
	$(CC) $(CFLAGS) $(BONUS_OBJS) ${LIB} -o $(BONUS_NAME)
	@echo "\033[32m$ ${NAME} compiled !"

# Rule for building the bonus
bonus: ${BONUS_NAME}

# Rule for cleaning up object files and the library
clean:
	make -C libft clean
	rm -rf $(OBJS_DIR)
	rm -rf $(BONUS_OBJS_DIR)

# Rule for cleaning up executables
fclean: clean
	rm -rf $(NAME)
	rm -rf $(BONUS_NAME)

# Rule for rebuilding
re: fclean all

# Rule for running valgrind
valgrind: debug
	valgrind --leak-check=full --show-leak-kinds=all --track-fds=yes --trace-children=yes ./$(NAME) $(ARGS)

# Rule for running helgrind
helgrind: debug
	valgrind --tool=helgrind ./$(NAME) $(ARGS)

# Rule for running drd
drd: debug
	valgrind --tool=drd ./$(NAME) $(ARGS)

# Rule for running callgrind
callgrind: debug
	valgrind --tool=callgrind ./$(NAME) $(ARGS)

# Rule for running scan-build
scan-build: clean
	@scan-build-12 -v make

# Rule for running valgrind on the bonus
valgrind_bonus: bonus
	valgrind --leak-check=full --show-leak-kinds=all --track-fds=yes --trace-children=yes ./$(BONUS_NAME) $(ARGS)

# Rule for running helgrind on the bonus
helgrind_bonus: bonus
	valgrind --tool=helgrind ./$(BONUS_NAME) $(ARGS)

# Rule for running drd on the bonus
drd_bonus: bonus
	valgrind --tool=drd ./$(BONUS_NAME) $(ARGS)

# Rule for running callgrind on the bonus
callgrind_bonus: bonus
	valgrind --tool=callgrind ./$(BONUS_NAME) $(ARGS)

# Rule for running scan-build on the bonus
scan-build_bonus: clean
	@scan-build-12 -v make bonus

# Rule for debug build
debug: CFLAGS += $(DEBUG)
debug: re

# Rule for fsanitize on bonus
fsanitize_bonus : CFLAGS += $(FSANITIZE_FLAGS)
fsanitize_bonus : re

# Rule for fsanitize
fsanitize : CFLAGS += $(FSANITIZE_FLAGS)
fsanitize : re

# Rule for fast build
fast : CFLAGS += $(FAST_FLAGS)
fast : re

# Rule for fast build on bonus
fast_bonus : CFLAGS += $(FAST_FLAGS)
fast_bonus : re

# Help rule
help:
	@echo "Usage:"
	@echo "  make [all]        Build the main and bonus executables"
	@echo "  make bonus        Build the bonus executable"
	@echo "  make clean        Clean up object files and the library"
	@echo "  make fclean       Clean up executables"
	@echo "  make re           Rebuild everything"
	@echo "  make valgrind     Run valgrind"
	@echo "  make helgrind     Run helgrind"
	@echo "  make drd          Run drd"
	@echo "  make callgrind    Run callgrind"
	@echo "  make scan-build   Run scan-build"
	@echo "  make debug        Build with debug flags"
	@echo "  make fsanitize    Build with sanitize flags"
	@echo "  make fast         Build with optimization flags"
	@echo "  make help         Display this help message"

# Phony rule to avoid conflicts with file names
.PHONY:	all clean fclean re drd callgrind helgrind valgrind scan-build callgrind_bonus drd_bonus helgrind_bonus valgrind_bonus scan-build_bonus debug fsanitize fast help
