//We need to include visitors and error.
namespace Iris
{
	class AST
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
			void visit(Visitor, Traverse);//Traverse might need to be created
			void visitChilds(Visitor, Traverse);
		protected:
			std::string fName;
			Int32 line, cBegin, nChild;
			std::vector<Iris::AST> child;
			AST *parent;
			void tab(Int32);
			std::string intToString(Int32, Int32);

	};
}
