# How to install boxes in CentOS7

## 설치
```
yum install -y boxes
```

### 사용법
```
$ boxes msg.txt
/*************/
/* hi threre */
/*************/
```

```
$ boxes -d boy msg.txt
.-"""-.
/ .===. \
\/ 6 6 \/
( \___/ )
_ooo__\_____/______
/                   \
| hi threre           |
\_______________ooo_/
|  |  |
|_ | _|
|  |  |
|__|__|
/-'Y'-\
(__/ \__)
```

```
$ echo "This is a test" | boxes
/******************/
/* This is a test */
/******************/
```

```
$ echo -e "This is a test\nthis is a line\n\nanother one\ntest" | boxes
/******************/
/* This is a test */
/* this is a line */
/*                */
/* another one    */
/* test           */
/******************/
```
