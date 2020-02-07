import std.stdio,std.algorithm;

void main(){
    3.exe!(x=>x*2).writeln;
    int[A] arr;
    arr[A(3,4)]=10;
    writeln((A(3,4) in arr)!=null?"yes":"no");
    writeln((A(5,2) in arr)!=null?"yes":"no");
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
