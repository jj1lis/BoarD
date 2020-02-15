import std;

void main(){
    //string reg="I am \033[40m !";
    //reg.splitter("\033").writeln;
    //reg.splitter("\033").array.length.writeln;
    //reg.replace(regex("\033.*m","g"),"").writeln;

    int c=2;

    auto func1=(int a){
        return a+2;
    };
    auto func2=(int b){
        return b+c;
    };

    writefln("%s func1(1)=%s, %s func2(1)=%s",typeof(func1).stringof,func1(1),typeof(func2).stringof,func2(1));
}
