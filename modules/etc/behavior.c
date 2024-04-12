#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#define filename "trace1.din"
//#define filename "address.txt"


struct i_cache {	/* 인스트럭션 캐시 구조체 */
    int tag;
    int valid;
    int lru;
};

struct d_cache { /* 데이터 캐시 구조체 */
    int tag;	/* 태그 */
    int valid;	/* valid bit */
    int dirty;	/* write back 시 dirty bit */
    int lru;
};

struct l2_cache {
    int tag;
    int valid;
    int dirty;
    int lru;
};

struct i_cache* ip; /* 인스트럭션 캐시를 가리키는 포인터 */
struct d_cache* dp; /* 데이터 캐시를 가리키는 포인터 */
struct l2_cache* l2p;

/* 전역 변수 */
int i_total, i_miss;    /* 인스트럭션 캐시 접근 횟수 및 miss 횟수 */
int d_total, d_miss, d_write;   /* 데이터 캐시 접근 횟수 및 miss 횟수, 메모리 쓰기 횟수 */
int l2_total, l2_miss, l2_write;

void simulation(int c_size, int b_size);
void read_data(unsigned int addr, int c_size, int b_size, int assoc);
void write_data(unsigned int addr, int c_size, int b_size, int assoc);
void read_data_2(unsigned int addr, int c_size, int b_size, int assoc);
void write_data_2(unsigned int addr, int c_size, int b_size, int assoc);
void fetch_inst(int addr, int c_size, int b_size, int assoc);



int main() {
    int cache = 4096;
    int block = 64;

    simulation(cache, block);
}

void simulation(int c_size, int b_size) {
    i_total = i_miss = 0;
    d_total = d_miss = d_write = 0;
    l2_total = l2_miss = l2_write = 0;

    int mode;
    unsigned int addr; /* 파일로부터 읽은 값을 저장하는 변수 */
    int num = c_size / b_size;    /*캐시블락의 개수 */
    int num2 = 65536 / b_size;
    double i_res, d_res, l2_res, total_res;    /* miss rate을 저장하는 변수 */
    FILE* fp = NULL;
    
    char rw, n;

    ip = (struct i_cache*)calloc(num, sizeof(struct i_cache));
    dp = (struct d_cache*)calloc(num, sizeof(struct d_cache));
    l2p = (struct d_cache*)calloc(num2, sizeof(struct l2_cache));
    
    fopen_s(&fp, filename, "r");
    while (!feof(fp)) {        
        fscanf_s(fp, "%d %x\n", &mode, &addr);

        switch (mode) {
        case 0:
            read_data(addr, c_size, b_size, 2);
            d_total++;
            break;
        case 1:
            write_data(addr, c_size, b_size, 2);
            d_total++;
            break;
        case 2:
            fetch_inst(addr, c_size, b_size, 2);
            i_total++;
            //read_data(addr, c_size, b_size, 2);
            //d_total++;
            break;
        }
        /*
        fscanf_s(fp, "%x\n", &addr);
        printf("Address : %.8x\n", addr);
        printf("R/W : ");
        scanf_s("%c", &rw);
        if (rw == 'r') {
            read_data(addr, c_size, b_size, 2);
        }
        else if (rw == 'w') {
            write_data(addr, c_size, b_size, 2);
        }
        else {
            printf("Error\n");
            continue;
        }
        d_total++;
        printf("\n");
        scanf_s("%c", &n);        
        */
    } 

    free(ip);
    free(dp);
    free(l2p);
    i_res = (double)i_miss / (double)i_total;
    d_res = (double)d_miss / (double)d_total;
    l2_res = (double)l2_miss / (double)l2_total;
    
    printf("total address number : %d\n", d_total + i_total);
    printf("d cache access : %d\n", d_total);
    printf("i cache access : %d\n", i_total);
    printf("L2 cache access : %d\n", l2_total);
    printf("cache size | block size | d-miss rate | i-miss rate | l2 write\n");
    printf("%10d   %10d   %11.4lf   %11.4lf   %8d\n", c_size, b_size, d_res, i_res, d_write);
    printf("cache size | block size | l2-miss rate | mem write\n");
    printf("%10d   %10d   %12.4lf   %9d\n", 65536, b_size, l2_res,l2_write);
    fclose(fp);
}


void read_data(unsigned int addr, int c_size, int b_size, int assoc) {
    int num_of_sets, set;   /* set의 개수와 입력받은 주소의 set을 저장하는 변수 */
    int i, j, ev = 0, avail = -1, hit = 0;  /* 반복문의 인덱스와 victim의 인덱스, 그리고 새로 넣을 블럭의 인덱스 */
    struct d_cache* p;  /* 캐시를 가리키는 포인터 */

    num_of_sets = c_size / (b_size * assoc);    /* set의 개수를 구한다. */
    set = (addr / b_size) % num_of_sets;  /* 입력받은 인자로부터 해당 주소의 set을 구한다. */
    //printf("Tag : %x, Index : %x\n", ((addr / b_size) / num_of_sets), set);

    /* 캐시에서 해당 set을 검색하여 HIT/MISS를 결정 */
    for (i = 0; i < assoc; i++) {
        p = &dp[set * assoc + i];

        /* valid bit이 1이고 tag값이 일치하면 접근 시간을 바꾸고 HIT */
        if (p->valid == 1 && p->tag == (addr / b_size) / num_of_sets) {
            for (j = 0; j < assoc; j++) {
                if (j != i) {
                    p = &dp[set * assoc + j];
                    (p->lru)--;
                }
                else {
                    p->lru = assoc - 1;
                }
            }
            //printf("L1 Cache Hit\n");;
            return;
        }
        /* 새로운 블럭이 들어갈 인덱스 */
        else if (p->valid == 0) {
            avail = i;
            break;
        }
    }


    /* set에 해당되는 블럭이 없으므로 MISS이고 새로운 블럭을 올린다. */
    d_miss++;
    //printf("L1 Cache Miss\n");
    /* 캐시의 set이 가득찬 경우 */
    if (avail == -1) {
        ev = evict(set, assoc, 'd');
        p = &dp[set * assoc + ev];
        //printf("(L1) Way %d is replaced.\n", ev);

        /* victim 블럭의 dirty bit이 1이면 메모리 쓰기를 한다. */
        if (p->dirty) {
            d_write++;
            //printf("Write data to L2 Cache.\n");
        }

        p->valid = 1;
        p->tag = (addr / b_size) / num_of_sets;
        p->dirty = 0;   //새로 올린 블럭이므로 dirty bit은 0이다.
        for (j = 0; j < assoc; j++) {
            if (j != ev) {
                p = &dp[set * assoc + j];
                if (p->lru != 0) {
                    (p->lru)--;
                }
                else {
                    p->lru = assoc - 1;
                }
            }
        }
    }
    /* 캐시의 set에 자리가 있는 경우 */
    else {
        p = &dp[set * assoc + avail];
        //printf("(L1) Way %d is replaced.\n", avail);

        p->valid = 1;
        p->tag = (addr / b_size) / num_of_sets;
        p->dirty = 0;
        for (j = 0; j < assoc; j++) {
            if (j != avail) {
                p = &dp[set * assoc + j];
                if (p->lru != 0) {
                    (p->lru)--;
                }
                else {
                    p->lru = assoc - 1;
                }
            }
        }
    }
    read_data_2(addr, 65536, b_size, 4); // L2 캐시 탐색
    l2_total++;
}

void read_data_2(unsigned int addr, int c_size, int b_size, int assoc) {
    int num_of_sets, set;   /* set의 개수와 입력받은 주소의 set을 저장하는 변수 */
    int i, j, ev = 0, avail = -1, hit = 0;  /* 반복문의 인덱스와 victim의 인덱스, 그리고 새로 넣을 블럭의 인덱스 */
    struct l2_cache* p;  /* 캐시를 가리키는 포인터 */

    num_of_sets = c_size / (b_size * assoc);    /* set의 개수를 구한다. */
    set = (addr / b_size) % num_of_sets;  /* 입력받은 인자로부터 해당 주소의 set을 구한다. */
    //printf("Tag : %x, Index : %x\n", ((addr / b_size) / num_of_sets), set);

    /* 캐시에서 해당 set을 검색하여 HIT/MISS를 결정 */
    for (i = 0; i < assoc; i++) {
        p = &l2p[set * assoc + i];

        /* valid bit이 1이고 tag값이 일치하면 접근 시간을 바꾸고 HIT */
        if (p->valid == 1 && p->tag == (addr / b_size) / num_of_sets) {
            for (j = 0; j < assoc; j++) {
                if (j != i) {
                    p = &l2p[set * assoc + j];
                    (p->lru)--;
                }
                else {
                    p->lru = assoc - 1;
                }
            }
            //printf("L2 Cache Hit\n");;
            return;
        }
        /* 새로운 블럭이 들어갈 인덱스 */
        else if (p->valid == 0) {
            avail = i;
            break;
        }
    }


    /* set에 해당되는 블럭이 없으므로 MISS이고 새로운 블럭을 올린다. */
    l2_miss++;
    //printf("L2 Cache Miss\n");
    /* 캐시의 set이 가득찬 경우 */
    if (avail == -1) {
        ev = evict(set, assoc, 'd');
        p = &l2p[set * assoc + ev];
        //printf("(L2) Way %d is replaced.\n", ev);

        /* victim 블럭의 dirty bit이 1이면 메모리 쓰기를 한다. */
        if (p->dirty) {
            l2_write++;
            //printf("Write data to Memory.\n");
        }

        p->valid = 1;
        p->tag = (addr / b_size) / num_of_sets;
        p->dirty = 0;   //새로 올린 블럭이므로 dirty bit은 0이다.
        for (j = 0; j < assoc; j++) {
            if (j != ev) {
                p = &l2p[set * assoc + j];
                if (p->lru != 0) {
                    (p->lru)--;
                }
                else {
                    p->lru = assoc - 1;
                }
            }
        }
    }
    /* 캐시의 set에 자리가 있는 경우 */
    else {
        p = &l2p[set * assoc + avail];
        //printf("(L2) Way %d is replaced.\n", avail);

        p->valid = 1;
        p->tag = (addr / b_size) / num_of_sets;
        p->dirty = 0;
        for (j = 0; j < assoc; j++) {
            if (j != avail) {
                p = &l2p[set * assoc + j];
                if (p->lru != 0) {
                    (p->lru)--;
                }
                else {
                    p->lru = assoc - 1;
                }
            }
        }
    }
}

void write_data(unsigned int addr, int c_size, int b_size, int assoc) {
    int num_of_sets, set;   /* set의 개수와 입력받은 주소의 set을 저장하는 변수 */
    int i, j, ev = 0, avail = -1;  /* 반복문의 인덱스와 victim의 인덱스, 그리고 새로 넣을 블럭의 인덱스 */
    struct d_cache* p;  /* 캐시를 가리키는 포인터 */

    num_of_sets = c_size / (b_size * assoc);    /* set의 개수를 구한다. */
    set = (addr / b_size) % num_of_sets;  /* 입력받은 인자로부터 해당 주소의 set을 구한다. */
    //printf("Tag : %x, Index : %x\n", ((addr / b_size) / num_of_sets), set);

    /* 캐시에서 해당 set을 검색하여 HIT/MISS를 결정 */
    for (i = 0; i < assoc; i++) {
        p = &dp[set * assoc + i];
        /* valid bit이 1이고 tag값이 일치하면 접근 시간을 바꾸고, dirty bit을 1로 변경하고 HIT */
        if (p->valid == 1 && p->tag == (addr / b_size) / num_of_sets) {
            for (j = 0; j < assoc; j++) {
                if (i != j) {
                    p = &dp[set * assoc + j];
                    if (j != i) {
                        p = &dp[set * assoc + j];
                        (p->lru)--;
                    }
                    else {
                        p->lru = assoc - 1;
                    }
                }
            }
            p->dirty = 1;
            //printf("L1 Cache Hit\n");
            return;
        }
        /* 새로운 블럭이 들어갈 인덱스 */
        else if (p->valid == 0) {
            avail = i;
            break;
        }
    }
    /* set에 해당되는 블럭이 없으므로 MISS이고 새로운 블럭을 올린다. */
    d_miss++;
    //printf("L1 Cache Miss\n");
    /* 캐시의 set이 가득찬 경우 */
    if (avail == -1) {
        ev = evict(set, assoc, 'd');
        p = &dp[set * assoc + ev];
        //printf("(L1) Way %d is replaced.\n", ev);

        /* victim 블럭의 dirty bit이 1이면 메모리 쓰기를 한다. */
        if (p->dirty) {
            d_write++;
            //printf("Write data to L2 Cache.\n");
        }

        p->valid = 1;
        p->tag = (addr / b_size) / num_of_sets;
        p->dirty = 1;   /* 새로 올린 블럭도 수정했으므로 dirty bit은 1 */
        for (j = 0; j < assoc; j++) {
            if (j != ev) {
                p = &dp[set * assoc + j];
                if (p->lru != 0) {
                    (p->lru)--;
                }
                else {
                    p->lru = assoc - 1;
                }
            }
        }
    }
    /* 캐시의 set에 자리가 있는 경우 */
    else {
        p = &dp[set * assoc + avail];
        //printf("(L1) Way %d is replaced.\n", avail);
        p->valid = 1;
        p->tag = (addr / b_size) / num_of_sets;
        p->dirty = 1;
        for (j = 0; j < assoc; j++) {
            if (j != avail) {
                p = &dp[set * assoc + j];
                if (p->lru != 0) {
                    (p->lru)--;
                }
                else {
                    p->lru = assoc - 1;
                }
            }
        }
    }
    write_data_2(addr, 65536, b_size, 4); // L2 캐시 탐색
    l2_total++;
}

void write_data_2(unsigned int addr, int c_size, int b_size, int assoc) {
    int num_of_sets, set;   /* set의 개수와 입력받은 주소의 set을 저장하는 변수 */
    int i, j, ev = 0, avail = -1;  /* 반복문의 인덱스와 victim의 인덱스, 그리고 새로 넣을 블럭의 인덱스 */
    struct l2_cache* p;  /* 캐시를 가리키는 포인터 */

    num_of_sets = c_size / (b_size * assoc);    /* set의 개수를 구한다. */
    set = (addr / b_size) % num_of_sets;  /* 입력받은 인자로부터 해당 주소의 set을 구한다. */
    //printf("Tag : %x, Index : %x\n", ((addr / b_size) / num_of_sets), set);

    /* 캐시에서 해당 set을 검색하여 HIT/MISS를 결정 */
    for (i = 0; i < assoc; i++) {
        p = &l2p[set * assoc + i];
        /* valid bit이 1이고 tag값이 일치하면 접근 시간을 바꾸고, dirty bit을 1로 변경하고 HIT */
        if (p->valid == 1 && p->tag == (addr / b_size) / num_of_sets) {
            for (j = 0; j < assoc; j++) {
                if (i != j) {
                    p = &l2p[set * assoc + j];
                    if (j != i) {
                        p = &l2p[set * assoc + j];
                        (p->lru)--;
                    }
                    else {
                        p->lru = assoc - 1;
                    }
                }
            }
            p->dirty = 1;
            //printf("L2 Cache Hit\n");
            return;
        }
        /* 새로운 블럭이 들어갈 인덱스 */
        else if (p->valid == 0) {
            avail = i;
            break;
        }
    }
    /* set에 해당되는 블럭이 없으므로 MISS이고 새로운 블럭을 올린다. */
    l2_miss++;
    //printf("L2 Cache Miss\n");
    /* 캐시의 set이 가득찬 경우 */
    if (avail == -1) {
        ev = evict(set, assoc, 'd');
        p = &l2p[set * assoc + ev];
        //printf("(L2) Way %d is replaced.\n", ev);

        /* victim 블럭의 dirty bit이 1이면 메모리 쓰기를 한다. */
        if (p->dirty) {
            l2_write++;
            //printf("Write data to Memory.\n");
        }

        p->valid = 1;
        p->tag = (addr / b_size) / num_of_sets;
        p->dirty = 1;   /* 새로 올린 블럭도 수정했으므로 dirty bit은 1 */
        for (j = 0; j < assoc; j++) {
            if (j != ev) {
                p = &l2p[set * assoc + j];
                if (p->lru != 0) {
                    (p->lru)--;
                }
                else {
                    p->lru = assoc - 1;
                }
            }
        }
    }
    /* 캐시의 set에 자리가 있는 경우 */
    else {
        p = &l2p[set * assoc + avail];
        //printf("(L2) Way %d is replaced.\n", avail);
        p->valid = 1;
        p->tag = (addr / b_size) / num_of_sets;
        p->dirty = 1;
        for (j = 0; j < assoc; j++) {
            if (j != avail) {
                p = &l2p[set * assoc + j];
                if (p->lru != 0) {
                    (p->lru)--;
                }
                else {
                    p->lru = assoc - 1;
                }
            }
        }
    }
}

void fetch_inst(int addr, int c_size, int b_size, int assoc) {
    int num_of_sets, set;   /* set의 개수와 입력받은 주소의 set을 저장하는 변수 */
    int i, j, ev = 0, avail = -1;  /* 반복문의 인덱스와 victim의 인덱스, 그리고 새로 넣을 블럭의 인덱스 */
    struct i_cache* p;  /* 캐시를 가리키는 포인터 */

    num_of_sets = c_size / (b_size * assoc);    /* set의 개수를 구한다. */
    set = (addr / b_size) % num_of_sets;  /* 입력받은 인자로부터 해당 주소의 set을 구한다. */


    /* 캐시에서 해당 set을 검색하여 HIT/MISS를 결정 */
    for (i = 0; i < assoc; i++) {
        p = &ip[set * assoc + i];
        /* valid bit이 1이고 tag값이 일치하면 접근 시간을 바꾸고 HIT */
        if (p->valid == 1 && p->tag == (addr / b_size) / num_of_sets) {
            for (j = 0; j < assoc; j++) {
                if (j != i) {
                    p = &ip[set * assoc + j];
                    (p->lru)--;
                }
                else {
                    p->lru = assoc - 1;
                }
            }
            return;
        }
        else if (p->valid == 0) {
                avail = i;
        }
    }

    /* set에 해당되는 블럭이 없으므로 MISS이고 새로운 블럭을 올린다. */
    i_miss++;

    /* 캐시의 set이 가득찬 경우 */
    if (avail == -1) {
        ev = evict(set, assoc, 'i');
        p = &ip[set * assoc + ev];

        p->valid = 1;
        p->tag = (addr / b_size) / num_of_sets;
        for (j = 0; j < assoc; j++) {
            if (j != ev) {
                p = &ip[set * assoc + j];
                if (p->lru != 0) {
                    (p->lru)--;
                }
                else {
                    p->lru = assoc - 1;
                }
            }
        }
    }
    else {
        p = &ip[set * assoc + avail];

        p->valid = 1;
        p->tag = (addr / b_size) / num_of_sets;
        for (j = 0; j < assoc; j++) {
            if (j != avail) {
                p = &ip[set * assoc + j];
                if (p->lru != 0) {
                    (p->lru)--;
                }
                else {
                    p->lru = assoc - 1;
                }
            }
        }
    }
    read_data_2(addr, 65536, b_size, 4); // L2 캐시 탐색
    l2_total++;
}

int evict(int set, int assoc, char mode) {
    int i, lru;  /* 반복문의 인덱스와 시간을 저장하는 변수 */
    int min = INT_MAX, min_i = 0;  /* 최소값을 찾기 위한 변수와 인덱스 변수 */

    /* set에서 lru값이 가장 작은 블럭의 인덱스를 찾아 return한다. */
    for (i = 0; i < assoc; i++) {
        if (mode == 'd')
            lru = dp[set * assoc + i].lru;
        else if (mode == 'i')
            lru = ip[set * assoc + i].lru;
        else if (mode == '2')
            lru = l2p[set * assoc + i].lru;

        if (min > lru) {
            min = lru;
            min_i = i;
        }
    }
    
    return min_i;
}