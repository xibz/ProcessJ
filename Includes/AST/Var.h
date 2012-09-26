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
				myDec(NULL)
			{
				c.Variable.child[NAME] = &n;
				c.Variable.child[EXPR] = NULL;
			}
			Var(Iris::Name n, Iris::Expression e):
				myDec(NULL)
			{
				c.Variable.child[NAME] = &n;
				c.Variable.child[EXPR] = &e;
			}
			Var(Iris::Var v, Iris::Literal l)
			{
				c.Variable.child[NAME] = &v.name(); //Might need to malloc this?
				c.Variable.childSeq.push_back(l);
			}
			Var(Var v, Expression e)
			{
				c.Variable.child[NAME] = &v.name();
				c.Variable.child[EXPR] = &e;
				for(i=0; i < v.c.Variable.childSeq.size(); ++i)
					c.Variable.childSeq.push_back(v.c.Variable.childSeq[i]);
			}
			Iris::Name name(){return (Iris::Name)(c.Variable.child[NAME]);}
			std::vector<AST> sizes(){return c.Variable.childSeq;} //Do I need to cast this?

			VarDecl myDec;
	};
}
#undef NAME
#undef EXPR
#endif
