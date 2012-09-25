#include <AST.h>

void Iris::AST::print(int n, string out)
{
	std::cout << "line" << this->intToString(line, 3) << ": ";

}

string Iris::AST::intToString(int i, int w)
{
	string s = "                "+Iris::Integer::toString(i);
	return s.substr(s.length-w); 
}

Object Iris::AST::visit(Visitor v, Object arg)
{
	Object v = { NULL, 0 };//Why would a child ever be NULL?
	for(int i = 0; i < child.size(); ++i)child[c].visit(v, arg);
	return v;
}
