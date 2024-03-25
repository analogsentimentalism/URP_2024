#include <stdio.h>
#include <stdlib.h>

//#define filename "trace1.din"
#define filename "address.txt"


struct i_cache {	/* 인스트럭션 캐시 구조체 */
    int tag;
    int valid;
};

struct d_cache { /* 데이터 캐시 구조체 */
    int tag;	/* 태그 */
    int valid;	/* valid bit */
    int dirty;	/* write back 시 dirty bit */
};

struct i_cache* ip; /* 인스트럭션 캐시를 가리키는 포인터 */
struct d_cache* dp; /* 데이터 캐시를 가리키는 포인터 */

/* 전역 변수 */
int i_total, i_miss;    /* 인스트럭션 캐시 접근 횟수 및 miss 횟수 */
int d_total, d_miss, d_write;   /* 데이터 캐시 접근 횟수 및 miss 횟수, 메모리 쓰기 횟수 */


void simulation(int c_size, int b_size);
void read_data(unsigned int addr, int c_size, int b_size);
void write_data(unsigned int addr, int c_size, int b_size);



int main() {
    int cache = 4096;
    int block = 64;

    simulation(cache, block);
}

void simulation(int c_size, int b_size) {
    i_total = i_miss = 0;
    d_total = d_miss = d_write = 0;

    //int mode;
    unsigned int addr; /* 파일로부터 읽은 값을 저장하는 변수 */
    int num = c_size / b_size;    //각 캐시의 크기
    double i_res, d_res;    /* miss rate을 저장하는 변수 */
    FILE* fp = NULL;
    
    char rw, n;

    ip = (struct i_cache*)calloc(num, sizeof(struct i_cache));
    dp = (struct d_cache*)calloc(num, sizeof(struct d_cache));

    
    fopen_s(&fp, filename, "r");
    while (!feof(fp)) {        
        /*
        fscanf_s(fp, "%d %x\n", &mode, &addr);

        switch (mode) {
        case 0:
            read_data(addr, c_size, b_size, assoc);
            d_total++;
            break;
        case 1:
            write_data(addr, c_size, b_size, assoc);
            d_total++;
            break;
        case 2:
            fetch_inst(addr, c_size, b_size, assoc);
            i_total++;
            break;
        }
        */
        fscanf_s(fp, "%x\n", &addr);
        printf("Address : %.8x\n", addr);
        printf("R/W : ");
        scanf_s("%c", &rw);
        if (rw == 'r') {
            read_data(addr, c_size, b_size);
        }
        else if (rw == 'w') {
            write_data(addr, c_size, b_size);
        }
        else {
            printf("Error\n");
            continue;
        }
        d_total++;
        printf("\n");
        scanf_s("%c", &n);        
    }
    /*
    printf("Address : ");
    while (scanf_s("%x", &addr) == 1) {
        if (addr < 4294967295) { // ffffffff
            read_data(addr, c_size, b_size);
            d_total++;
        }
        else {
            break;
        }
        printf("Address : ");
    }
    */
    

    free(ip);
    free(dp);
    i_res = (double)i_miss / (double)i_total;
    d_res = (double)d_miss / (double)d_total;

    printf("cache size | block size | d-miss rate | i-miss rate | mem write\n");
    printf("%10d   %10d        %.4lf     %.4lf  %10d\n", c_size, b_size, d_res, i_res, d_write);
    fclose(fp);
}

void read_data(unsigned int addr, int c_size, int b_size) {
    int num_of_sets, set;   /* set의 개수와 입력받은 주소의 set을 저장하는 변수 */
    int avail = 1;  /* 반복문의 인덱스와 victim의 인덱스, 그리고 새로 넣을 블럭의 인덱스 */
    struct d_cache* p;  /* 캐시를 가리키는 포인터 */

    num_of_sets = c_size / (b_size);    /* block 개수를 구한다. */
    set = (addr / b_size) % num_of_sets;  /* index를 구한다. */

    /* 캐시에서 해당 set을 검색하여 HIT/MISS를 결정 */
    p = &dp[set];
    printf("Tag : %x, Index : %x, Valid : %d, Dirty : %d\n", p->tag, set, p->valid, p->dirty);
    printf("New Tag : %x\n", ((addr / b_size) / num_of_sets));
        /* valid bit이 1이고 tag값이 일치하면 HIT */
    if (p->valid == 1 && p->tag == (addr / b_size) / num_of_sets) {
        printf("Hit\n");
        return;
    }
        /* 새로운 블럭이 들어갈 인덱스 */
    else if (p->valid == 0) {
        avail = 0;
    }
    /* set에 해당되는 블럭이 없으므로 MISS이고 새로운 블럭을 올린다. */
    d_miss++;
    printf("Miss\n");
    /* 캐시의 set이 가득찬 경우 */
    if (avail == 1) {
        p = &dp[set];

        /* victim 블럭의 dirty bit이 1이면 메모리 쓰기를 한다. */
        if (p->dirty) {
            d_write++;
            printf("Write data to memory.\n");
        }

        p->valid = 1;
        p->tag = (addr / b_size) / num_of_sets;
        p->dirty = 0;   //새로 올린 블럭이므로 dirty bit은 0이다.

    }
    /* 캐시의 set에 자리가 있는 경우 */
    else {
        p = &dp[set];

        p->valid = 1;
        p->tag = (addr / b_size) / num_of_sets;
        p->dirty = 0;
    }
}

void write_data(unsigned int addr, int c_size, int b_size) {
    int num_of_sets, set;   /* set의 개수와 입력받은 주소의 set을 저장하는 변수 */
    int avail = 1;  /* 반복문의 인덱스와 victim의 인덱스, 그리고 새로 넣을 블럭의 인덱스 */
    struct d_cache* p;  /* 캐시를 가리키는 포인터 */

    num_of_sets = c_size / (b_size);    /* set의 개수를 구한다. */
    set = (addr / b_size) % num_of_sets;  /* 입력받은 인자로부터 해당 주소의 set을 구한다. */


    /* 캐시에서 해당 set을 검색하여 HIT/MISS를 결정 */
    p = &dp[set];
    printf("Tag : %x, Index : %x, Valid : %d, Dirty : %d\n", p->tag, set, p->valid, p->dirty);
    printf("New Tag : %x\n", ((addr / b_size) / num_of_sets));
    /* valid bit이 1이고 tag값이 일치하면 접근 시간을 바꾸고, dirty bit을 1로 변경하고 HIT */
    if (p->valid == 1 && p->tag == (addr / b_size) / num_of_sets) {
        p->dirty = 1;
        printf("Hit\n");
        return;
    }
    else if (p->valid == 0) {
        avail = 0;
    }

    /* set에 해당되는 블럭이 없으므로 MISS이고 새로운 블럭을 올린다. */
    d_miss++;
    printf("Miss\n");
    /* 캐시의 set이 가득찬 경우 */
    if (avail == 1) {
        p = &dp[set];

        /* victim 블럭의 dirty bit이 1이면 메모리 쓰기를 한다. */
        if (p->dirty) {
            d_write++;
            printf("Write data to memory.\n");
        }

        p->valid = 1;
        p->tag = (addr / b_size) / num_of_sets;
        p->dirty = 1;   /* 새로 올린 블럭도 수정했으므로 dirty bit은 1 */
    }
    /* 캐시의 set에 자리가 있는 경우 */
    else {
        p = &dp[set];
        p->valid = 1;
        p->tag = (addr / b_size) / num_of_sets;
        p->dirty = 1;
    }
}