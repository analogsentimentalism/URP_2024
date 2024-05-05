int main () {
	volatile int i;
	i=1;
	i=2;
	i=3;
	i=4;
	volatile int j;
	for(j=0; j<10; j=j+1) {
		if(j==i) break;
	}
	i=0;
	j=0;
	return 0;
}