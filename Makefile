NAME     = pipex
BONUS_NAME = pipex_bonus
SRCS_DIR = srcs
BONUS_DIR = bonus
OBJS_DIR = objs
BONUS_OBJS_DIR = bonus_objs
SRCS    := $(shell find srcs/*.c -exec basename \ {} \;)
BONUS   := $(shell find bonus/*.c -exec basename \ {} \;)
OBJS     = ${patsubst %.c,${OBJS_DIR}/%.o,${SRCS}}
BONUS_OBJS = ${patsubst %.c,${BONUS_OBJS_DIR}/%.o,${BONUS}}
CC       = gcc
CFLAGS   = -Wall -Wextra -Werror
FSANITIZE_FLAGS = -g3 -fsanitize=address -fsanitize=undefined
VALGRIND_FLAGS = -g3
LIB      = libft/libft.a
HEADERS  = includes/pipex.h
BONUS_HEADERS = includes/pipex_bonus.h

all: $(NAME)

$(OBJS_DIR):
	@mkdir -p $(OBJS_DIR)
	@echo "\033[33mcompiling ${NAME}..."
	@echo "SRCS = ${SRCS}"
	@echo "OBJS = ${OBJS}"

$(BONUS_OBJS_DIR):
	@mkdir -p $(BONUS_OBJS_DIR)
	@echo "\033[33mcompiling ${BONUS_NAME}..."
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
	@echo "\033[32m$ ${BONUS_NAME} compiled !"

bonus: ${BONUS_NAME}

fsanitize: CFLAGS += $(FSANITIZE_FLAGS)
fsanitize: all

valgrind: CFLAGS += $(VALGRIND_FLAGS)
valgrind: all
	valgrind --leak-check=full --track-fds=yes --show-leak-kinds=all --track-origins=yes ./$(NAME)

debug: fsanitize valgrind

clean:
	make -C libft clean
	rm -rf $(OBJS_DIR)
	rm -rf $(BONUS_OBJS_DIR)

fclean
