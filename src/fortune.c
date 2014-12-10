/*
 * Filename:	fortune.c
 *
 * Author:		Oxnz
 * Email:		yunxinyi@gmail.com
 * Created:		[2014-11-26 10:00:44 CST]
 * Last-update:	2014-11-26 10:00:44 CST
 * Description: anchor
 *
 * Version:		0.0.1
 * Revision:	[NONE]
 * Revision history:	[NONE]
 * Date Author Remarks:	[NONE]
 *
 * License:
 * Copyright (c) 2013 Oxnz
 *
 * Distributed under terms of the [LICENSE] license.
 * [license]
 *
 */

#include <stdio.h>
#include <stdlib.h>

char choice[2048];
char *fortunes = "~/.shell/data/fortunes";
char *index = "~/.shell/data/fortunes.index";

int main(int argc, char *argv[]) {
	int i;
	long offs;
	uchar off[4];
	int ix, nix;
	int newindex, oldindex;
	char *p;
	Dir *fbuf, *ixbuf;
	FILE *f;
	Biobuf *f, g;

	newindex = 0;
	oldindex = 0;
	ix = offs = 0;
	if((f=fopen(argc>1 ? argv[1] : fortunes, OREAD)) == 0){
		print("Misfortune!\n");
		exits("misfortune");
	}
	ixbuf = nil;
	if(argc == 1){
		ix = open(index, OREAD);
		if(ix>=0){
			oldindex = 1;
			ixbuf = dirfstat(ix);
			fbuf = dirfstat(Bfildes(f));
			if(ixbuf == nil || fbuf == nil){
				print("Misfortune?\n");
				exits("misfortune");
			}
			if(fbuf->mtime > ixbuf->mtime){
				nix = create(index, OWRITE, 0666);
				if(nix >= 0){
					close(ix);
					ix = nix;
					newindex = 1;
					oldindex = 0;
				}
			}
		}else{
			ix = create(index, OWRITE, 0666);
			if(ix >= 0)
				newindex = 1;
		}
	}
	if(oldindex){
		srand(getpid());
		seek(ix, lrand()%(ixbuf->length/sizeof(offs))*sizeof(offs), 0);
		read(ix, off, sizeof(off));
		Bseek(f, off[0]|(off[1]<<8)|(off[2]<<16)|(off[3]<<24), 0);
		p = Brdline(f, '\n');
		if(p){
			p[Blinelen(f)-1] = 0;
			strcpy(choice, p);
		}else
			strcpy(choice, "Misfortune!");
	}else{
		Binit(&g, ix, 1);
		srand(getpid());
		for(i=1;;i++){
			if(newindex)
				offs = Boffset(f);
			p = Brdline(f, '\n');
			if(p == 0)
				break;
			p[Blinelen(f)-1] = 0;
			if(newindex){
				off[0] = offs;
				off[1] = offs>>8;
				off[2] = offs>>16;
				off[3] = offs>>24;
				Bwrite(&g, off, sizeof(off));
			}
			if(lrand()%i==0)
				strcpy(choice, p);
		}
	}
	print("%s\n", choice);
	exits(0);
}
