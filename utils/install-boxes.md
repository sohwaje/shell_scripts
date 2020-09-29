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
