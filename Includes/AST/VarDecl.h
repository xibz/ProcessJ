/*
	Variable delaration
*/
#ifndef _VARDECL_H
#define _VARDECL_H
namespace Iris
{
	class VarDecl
	{
		public:
			/*
				@return 
					Returns the type for the declared variable
			*/
			Iris::Type type();
			/*
				@return
					Returns the name of the variable
			*/
			std::string name();
			bool isMobile();
		private:
	};
}
#endif
