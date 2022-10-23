#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

def main():
	lst1 = sys.argv[1].split(' ')
	lst2 = sys.argv[2].split(' ')
	out = ""
	for i in lst1:
		if i not in lst2:
			out += " " + i
	print(out)

if __name__ == '__main__':
	main()
