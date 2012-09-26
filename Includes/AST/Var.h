#ifndef _VAR_H
#define _VAR_H
#define NAME 0
#define EXPR 1
namespace Iris
{
	class Var:public AST
	{
		public:
			Var(Iris::Name n):
			{
				child[NAME] = &n;
				child[EXPR] = NULL;
			}
			Var(Iris::Name n, Iris::Expression e):
			{
				child[NAME] = &n;
				child[EXPR] = &e;
			}
			Var(Iris::Var v, Iris::Literal l)
			{
				child[NAME] = &v.name(); //Might need to malloc this?
				childSeq.push_back(l);
			}
			Var(Var v, Expression e)
			{
				child[NAME] = &v.name();
				child[EXPR] = &e;
				childSeq(v.c.Variable.childSeq);
				//for(i=0; i < v.c.Variable.childSeq.size(); ++i)
					//c.Variable.childSeq.push_back(v.c.Variable.childSeq[i]);
			}
			Iris::Name name(){return (Iris::Name)(child[NAME]);}
			std::vector<AST> sizes(){return childSeq;} //Do I need to cast this?

			VarDecl myDec;
			AST child[2]
	};
}
#undef NAME
#undef EXPR
#endif
