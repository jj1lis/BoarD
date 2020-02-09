import std;

void main(){
    string reg="I am \033[40m !";
    //(reg~"\033[0m").writeln;
    //reg.length.writeln;
    //reg=replace(reg,regex("\033.*m","g"),"");
    //reg.writeln;
    reg.splitter("\033").writeln;
    reg.splitter("\033").array.length.writeln;
    reg.replace(regex("\033.*m","g"),"").writeln;
}

enum A{
    a="aa",
    b="bb",
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
