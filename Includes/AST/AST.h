//We need to include visitors and error.
#ifndef _AST_H
#define _AST_H
namespace Iris
{
	class AST:public Object
	{
		public:
			AST():
				parent(NULL)
			{
			}
			AST(const Int32 _line, const Int32 c):
				line(_line), cBegin(c)
			{
				parent = NULL;
			}
			AST(Iris::Token t):
				line(t.line), cBegin(t.cBegin)
			{
				parent = NULL;
			}
			AST(Iris::AST *n)
			{
				//fName = Error.fileName;
				if(n==NULL)
					line = cBegin = 0;
				else
				{
					line = n->line;
					cBegin = n->cBegin;
				}
			} 
			virtual std::string toString(){ return ""; }
			std::string getName();
			void visit(Visitor, Traverse);
			void visitChilds(Visitor, Traverse);

			std::string fName;
			Int32 line, cBegin, nChild;//nChild might not be needed.
			std::vector<Iris::AST> childSeq;
			AST *parent;
		protected:
			void tab(Int32);
			std::string intToString(Int32, Int32);

	};
}
#endif
