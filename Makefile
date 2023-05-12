# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kdhrif <kdhrif@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/11/29 14:25:53 by kdhrif            #+#    #+#              #
#    Updated: 2023/05/12 22:02:21 by kdhrif           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME     		= pipex
BONUS_NAME 		= pipex_bonus
SRCS_DIR 		= srcs
BONUS_DIR 		= bonus
OBJS_DIR 		= objs
BONUS_OBJS_DIR 	= bonus_objs
SRCS			= $(shell find srcs/*.c -exec basename \ {} \;)
BONUS			= $(shell find bonus/*.c -exec basename \ {} \;)
OBJS     		= ${patsubst %.c,${OBJS_DIR}/%.o,${SRCS}}
BONUS_OBJS 		= ${patsubst %.c,${BONUS_OBJS_DIR}/%.o,${BONUS}}
CC       		= gcc
CFLAGS   		= -Wall -Wextra -Werror
DEBUG           = -g3
FSANITIZE_FLAGS = -fsanitize=address -fsanitize=undefined
FAST_FLAGS      = -Ofast -flto -march=native
LIB      		= libft/libft.a
HEADERS  		= includes/pipex.h
BONUS_HEADERS 	= includes/pipex_bonus.h

all: $(NAME) $(BONUS_NAME)

$(OBJS_DIR):
	@mkdir -p $(OBJS_DIR)
	@echo "\033[33mcompiling ${NAME}..."
	@echo "SRCS = ${SRCS}"
	@echo "OBJS = ${OBJS}"

$(BONUS_OBJS_DIR):
	@mkdir -p $(BONUS_OBJS_DIR)
	@echo "\033[33mcompiling ${NAME}..."
	@echo "SRCS = ${BONUS}"
	@echo "OBJS = ${BONUS_OBJS}"

${OBJS_DIR}/%.o: ${SRCS_DIR}/%.c
	@${CC} ${CFLAGS} -c $< -o $@

${LIB} :
	@make -C libft

${NAME}: $(LIB) $(OBJS_DIR) $(OBJS) ${HEADERS}
	$(CC) $(CFLAGS) $(OBJS) ${LIB} -o $(NAME)
	@echo "\033[32m$ ${NAME} compiled !"

${BONUS_OBJS_DIR}/%.o: ${BONUS_DIR}/%.c
	@${CC} ${CFLAGS} -c $< -o $@

${BONUS_NAME}: $(LIB) $(BONUS_OBJS_DIR) $(BONUS_OBJS) ${BONUS_HEADERS}
	$(CC) $(CFLAGS) $(BONUS_OBJS) ${LIB} -o $(BONUS_NAME)
	@echo "\033[32m$ ${NAME} compiled !"

bonus: ${BONUS_NAME}

clean:
	make -C libft clean
	rm -rf $(OBJS_DIR)
	rm -rf $(BONUS_OBJS_DIR)

fclean: clean
	rm -rf $(NAME)
	rm -rf $(BONUS_NAME)

re: fclean all

valgrind: debug
	valgrind --leak-check=full --show-leak-kinds=all --track-fds=yes --trace-children=yes ./$(NAME) $(ARGS)

helgrind: debug
	valgrind --tool=helgrind ./$(NAME) $(ARGS)

drd: debug
	valgrind --tool=drd ./$(NAME) $(ARGS)

callgrind: debug
	valgrind --tool=callgrind ./$(NAME) $(ARGS)

scan-build: clean
	@scan-build-12 -v make

valgrind_bonus: bonus
	valgrind --leak-check=full --show-leak-kinds=all --track-fds=yes --trace-children=yes ./$(BONUS_NAME) $(ARGS)

helgrind_bonus: bonus
	valgrind --tool=helgrind ./$(BONUS_NAME) $(ARGS)

drd_bonus: bonus
	valgrind --tool=drd ./$(BONUS_NAME) $(ARGS)

callgrind_bonus: bonus
	valgrind --tool=callgrind ./$(BONUS_NAME) $(ARGS)

scan-build_bonus: clean
	@scan-build-12 -v make bonus

debug: CFLAGS += $(DBGFLAGS)
debug: re

fsanitize_bonus : CFLAGS += $(FSANITIZE_FLAGS)
fsanitize_bonus : re

fsanitize : CFLAGS += $(FSANITIZE_FLAGS)
fsanitize : re

.PHONY:	all clean fclean re drd callgrind helgrind valgrind scan-build callgrind_bonus drd_bonus helgrind_bonus valgrind_bonus scan-build_bonus
