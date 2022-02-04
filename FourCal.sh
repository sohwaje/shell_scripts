#!/bin/bash
add()
{
    result=$(($1 + $2))
    echo $result
}

sub()
{
    result=$(($1 - $2))
    echo $result
}

mul()
{
    result=$(($1 * $2))
    echo $result
}

div()
{
    # 소수점 두 자리까지 표시
    result=$(echo "scale=2 ; $1 / $2" |bc)
    echo $result
}

echo "Enter Two number: "
read a
read b

echo "Enter Choice: "
echo "1) + "
echo "2) - "
echo "3) * "
echo "4) / "
read ch

case $ch in
1) add $a $b
;;
2) sub $a $b
;;
3) mul $a $b
;;
4) div $a $b
;;
esac
