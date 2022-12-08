#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CHANGE_DIRECTORY 0
#define LIST_FILES 1
#define ADD_FILES 2

char STEP = 2;

size_t THRESHOLD = 100000;
size_t AVAILABLE_SPACE = 70000000;
size_t NEEDED_SPACE = 30000000;

typedef struct File {
    size_t size;
    bool dir;
    char *name;
    struct File *parent;
    struct File **children;
    bool visited;
} File;

/** For debugging */
void print_tree(File *file) {
    if (!file) return;

    File *current = file;
    while (current) {
        printf("/%s(%ld)", current->name, current->size);
        current = current->parent;
    }
    printf("\n");
    if (!file->children) return;
    for (int i = 0; file->children[i]; i++) {
        print_tree(file->children[i]);
    }
}

/** For debugging */
void print_path(File *file) {
    if (!file) return;
    print_path(file->parent);
    printf("%s/", file->name);
}

size_t get_step_1_sum(File *file) {
    if (!file->dir || !file->children || file->visited) {
        return 0;
    }
    file->visited = true;
    size_t sum = 0;
    if (file->size <= THRESHOLD) {
        sum += file->size;
    }
    for (int i = 0; file->children[i]; i++) {
        sum += get_step_1_sum(file->children[i]);
    }

    return sum;
}

size_t get_step_2_result_inner(File *file, size_t min, size_t result) {
    if (!file->dir || !file->children || file->visited) {
        return result;
    }
    file->visited = true;

    for (int i = 0; file->children[i]; i++) {
        int tmp = get_step_2_result_inner(file->children[i], min, result);
        if (tmp < result) result = tmp;
    }

    if (file->size < result && file->size >= min) {
        return file->size;
    }

    return result;
}

size_t get_step_2_result(File *root) {
    size_t result = __INT64_MAX__;
    size_t min = root->size - (AVAILABLE_SPACE - NEEDED_SPACE);
    return get_step_2_result_inner(root, min, result);
}

File *change_directory(File *current, char *name) {
    if (strcmp(name, "..") == 0) {
        return current->parent;
    }

    int i = -1;
    while (strcmp(current->children[++i]->name, name))
        ;

    return current->children[i];
}

File *add_file(File *current, char *line) {
    File *file = (File *)malloc(sizeof(File));
    char *name = malloc(sizeof(char));
    name = strtok(line, " ");
    if (strncmp("dir", name, strlen(line)) == 0) {
        name = strtok(NULL, " ");
        char *dirname = (char *)malloc(sizeof(char));
        strcpy(dirname, name);
        file->size = 0;
        file->name = dirname;
        file->dir = true;
        file->parent = current;
        file->children = NULL;
        file->visited = false;
    } else {
        sscanf(name, "%ld", &file->size);

        name = strtok(NULL, " ");
        char *filename = (char *)malloc(sizeof(char));
        strcpy(filename, name);

        file->name = filename;
        file->dir = false;
        file->parent = current;
        file->children = NULL;
        file->visited = false;

        File *parent = file->parent;
        while (parent) {
            parent->size += file->size;
            parent = parent->parent;
        }
    }

    if (!current->children) {
        current->children = (File **)malloc(sizeof(File));
        current->children[0] = file;
    } else {
        int i = 0;
        while (current->children[i]) {
            i++;
        }
        current->children = (File **)realloc(current->children, i * sizeof(File));
        current->children[i] = file;
    }

    return current;
}

int command(char *line) {
    if (line[0] != '$') return ADD_FILES;
    if (line[2] == 'c' && line[3] == 'd') return CHANGE_DIRECTORY;
    return LIST_FILES;
}

void solve(char filename[]) {
    FILE *f;

    if ((f = fopen(filename, "r")) == NULL) {
        printf("Error opening a file");
        exit(1);
    }

    File *root = (File *)malloc(sizeof(File));
    root->size = 0;
    root->name = (char *)malloc(sizeof(char));
    root->name = "/";
    root->dir = true;
    root->parent = NULL;
    root->children = (File **)malloc(sizeof(File));
    root->children = NULL;
    root->visited = false;

    File *current = root;

    size_t len = 0;
    size_t read;
    char *line = NULL;
    getline(&line, &len, f);  // Skip first line as it is "$ cd /""
    while ((read = getline(&line, &len, f)) != -1) {
        line = strtok(line, "\n");
        switch (command(line)) {
            case CHANGE_DIRECTORY:
                current = change_directory(current, &line[5]);
                break;
            case ADD_FILES:
                current = add_file(current, line);
                break;
            case LIST_FILES:
            default:
                break;
        }
    }

    if (STEP == 1) {
        printf("%ld\n", get_step_1_sum(root));
    } else {
        printf("%ld\n", get_step_2_result(root));
    }

    if (line) free(line);

    fclose(f);
}

int main() {
    solve("data/input.txt");
    return 0;
}