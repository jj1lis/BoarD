import std;

void main(){
    3.exe!(x=>x*2).writeln;
}

auto exe(alias f=x=>x+1,R)(R arg){
    return f(arg);
}
