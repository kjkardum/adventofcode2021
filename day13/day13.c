#include <stdio.h>
#include <stdlib.h>

struct point
{
    int x;
    int y;
};

struct fold
{
    char axis;
    int value;
};

const int points = 799; // 18 or 799
const int folds_count = 12; // 2 or 12
void readInput(struct point *p, struct fold *f)
{
    FILE *fp = fopen("input.txt", "r"); // demo.txt or input.txt
    for (int i=0; i<points; i++)
        fscanf(fp, "%d,%d", &p[i].x, &p[i].y);
    char c;
    do { c = fgetc(fp); } while (c != '\n');
    for (int i=0; i<folds_count; i++)
        fscanf(fp, "%[^g]g %c=%d", &f[i].axis, &f[i].axis, &f[i].value);
    fclose(fp);
}
int part1(struct point *input, struct fold fold)
{
    int count = 0;
    for (int i=0; i<points; i++)
        if (fold.axis == 'y')
        {
            if (input[i].y > fold.value)
                input[i].y = fold.value - (input[i].y - fold.value);
                
        }
        else
            if (input[i].x > fold.value)
                input[i].x = fold.value - (input[i].x - fold.value);
    for (int i=0; i<points; i++)
    {
        int unique = 1;
        for (int j=0; j<points; j++)
            if (i > j)
                if (input[i].x == input[j].x && input[i].y == input[j].y)
                    unique = 0;
        if (unique)
            count++;
    }
    return count;
}
void part2(struct point *input, struct fold *folds)
{
    for(int f=0; f<folds_count; f++) {
        int minix = 1500, miniy = 1500;
        for (int i=0; i<points; i++)
            if (folds[f].axis == 'y')
            {
                if (input[i].y > folds[f].value) {
                    input[i].y = folds[f].value - (input[i].y - folds[f].value);
                    if (input[i].y < miniy)
                        miniy = input[i].y;
                }
            }
            else
                if (input[i].x > folds[f].value) {
                    input[i].x = folds[f].value - (input[i].x - folds[f].value);
                    if (input[i].x < minix)
                        minix = input[i].x;
                }
    }
    for (int i=0; i<6; i++)
    {
        for (int j=0; j<40; j++)
        {
            int found = 0;
            for (int p=0; p<points; p++)
                if (input[p].x == j && input[p].y == i) {
                    found = 1;
                    break;
                }
            if (found)
                printf("#");
            else
                printf(".");
        }
        printf("\n");
    }
}

int main(void) {
    struct point *input = malloc(sizeof(struct point) * 800);
    struct fold *folds = malloc(sizeof(struct fold) * 15);
    readInput(input, folds);
    printf("Part 1: %d\n", part1(input, folds[0]));
    part2(input, folds);
}