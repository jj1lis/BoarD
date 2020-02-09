#!/usr/bin/rdmd

import std;

void main(){
    3.exe!(x=>x*2).writeln;
    int[A] arr;
    arr[A(3,4)]=10;
    writeln((A(3,4) in arr)!=null?"yes":"no");
    writeln((A(5,2) in arr)!=null?"yes":"no");

    writeln("|"~iota(-1,10).map!(i=>" "~i.to!string~" ").join~"|");
    writefln("|%(%3s |%)|",iota(-12,10));
    writefln("|%(%3s |%)|",iota(-12,10).map!(i=>i.to!string.length));
    auto str=iota(-12,10).array.sort.map!(i=>i.center(5)).join("|");
    typeof(iota(-12,10)).stringof.writeln;
    writefln("|%s|",str);

    EN[EN] arar;
    arar[EN.a]=EN.a;
    typeof(arar[EN.a]).stringof.writeln;
    arar[EN.a].ENTO.writeln;
}

auto exe(alias f=x=>x+1,R)(R arg){
    return f(arg);
}

struct A{
    int x;
    int y;
    this(int x,int y){
        this.x=x;
        this.y=y;
    }
}

auto center(long i,size_t width){
    auto len=i.to!string.length;
    if(width>len){
        if((width-len)%2==0){
            auto space=" ".repeat((width-len)/2).join;
            return space~i.to!string~space;
        }else{
            auto space=" ".repeat((width-len)/2).join;
            return space~i.to!string~space~" ";
        }
    }else{
        return i.to!string;
    }
}

auto ENTO(EN x){
    switch(x){
        case EN.a:
            return "aa";
        case EN.b:
            return "bb";
        case EN.c:
            return "cc";
        default:
            assert(0);
    }
}
enum EN{
    a,
    b,
    c
}
