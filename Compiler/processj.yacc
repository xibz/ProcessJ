%{
#include <stdio.h>
#include <string.h>

void yyerror(const char *str) {
  printf("error: %s\n",str);
}
 
int yywrap() {
  return 1;
} 

int main()
{
        yyparse();
	return 1;
} 

%}
// _____________________________________________________________________________
// Terminals
// _____________________________________________________________________________

%token CONST BOOLEAN BYTE INT LONG SHORT FLOAT STRING DOUBLE CHAR PROC MOBILE
%token CHAN BARRIER TIMER READ WRITE SHARED TIMEOUT SKIP STOP SYNC CLAIM SEQ PAR IF
%token ELSE FOR WHILE SWITCH CASE DO DEFAULT BREAK CONTINUE RETURN NEW RESUME SUSPEND
%token WITH PRI ALT PROTOCOL EXTENDS VOID IMPLEMENTS RECORD ENROLL PACKAGE IMPORT NATIVE
%token PUBLIC PRIVATE PROTECTED LPAREN RPAREN LBRACE RBRACE COLON SEMICOLON COMMA DOT 
%token LBRACK RBRACK EQ GT LT LSHIFT RSHIFT URSHIFT NOT COMP EQEQ LTEQ GTEQ NOTEQ ANDAND 
%token OROR PLUSPLUS MINUSMINUS PLUS MINUS MULT DIV AND OR XOR MOD MULTEQ DIVEQ MODEQ 
%token PLUSEQ MINUSEQ LSHIFTEQ RSHIFTEQ URSHIFTEQ ANDEQ XOREQ OREQ QUEST
%token INTEGER_LITERAL LONG_LITERAL FLOAT_LITERAL DOUBLE_LITERAL BOOLEAN_LITERAL
%token STRING_LITERAL CHARACTER_LITERAL IDENTIFIER

// ********************************************************************************
// ********************************************************************************
// PRODUCTIONS
// ********************************************************************************
// ********************************************************************************
%start source

%%

// **************************************************
// 1.0 Source
// **************************************************

source : 
        compilation_unit
      ;

// **************************************************
// 2.0 Type Declarations
// **************************************************

type_declarations :
        type_declarations type_declaration
      | type_declaration
      ;

type_declaration : 
        procedure_type_declaration 
      | record_type_declaration
      | protocol_type_declaration
      | constant_declaration              
      ;

// **************************************************
// 2.1 Procedure Types
// **************************************************

procedure_type_declaration : 
        modifiers_opt PROC type IDENTIFIER LPAREN formal_parameter_list_opt RPAREN implements_opt body_opt
      | modifiers_opt PROC VOID IDENTIFIER LPAREN formal_parameter_list_opt RPAREN implements_opt body_opt
      ;

body_opt :
        block
      | SEMICOLON
      | /* Epsilon */
      ;

implements_opt : 
        IMPLEMENTS type_list
      | /* Epsilon */
      ;

type_list : 
        type_list COMMA IDENTIFIER
      | IDENTIFIER
      ;

formal_parameter_list_opt :
        formal_parameter_list
      | /* Epsilon */
      ;

formal_parameter_list : 
        formal_parameter_list COMMA formal_parameter
      | formal_parameter
      ;

formal_parameter : 
        modifiers_opt type variable_declarator_identifier
       ;

// **************************************************
// 2.2 Protocol Types
// **************************************************

protocol_type_declaration : 
        modifiers_opt PROTOCOL IDENTIFIER extends_opt protocol_body
      | modifiers_opt PROTOCOL IDENTIFIER extends_opt SEMICOLON
      ;

extends_opt :
        EXTENDS type_list
      | /* Epsilon */
      ;

protocol_body : 
        LBRACE protocol_cases RBRACE
      ;

protocol_cases :
        protocol_cases protocol_case
      | protocol_case
      ;

protocol_case : 
        IDENTIFIER COLON LBRACE protocol_case_declarations RBRACE
      ;

protocol_case_declarations :
        protocol_case_declarations SEMICOLON type variable_declarator_identifier 
      | type variable_declarator_identifier 
      ;

// **************************************************
// 2.3 Record Types
// **************************************************

record_type_declaration : 
        modifiers_opt RECORD IDENTIFIER extends_opt record_body
      ;

record_body : 
        LBRACE record_member_declarations RBRACE
      ;

record_member_declarations :
        record_member_declarations record_member_declaration
      | record_member_declaration
      ;

record_member_declaration : 
        type record_member_declarators SEMICOLON
      ;

record_member_declarators : 
        record_member_declarators COMMA record_member_declarator
      | record_member_declarator
      ;

record_member_declarator : 
        variable_declarator_identifier
      ;

// **************************************************
// 3.0 Types
// **************************************************

type : 
        primitive_type
      | array_type
      | channel_type
      | named_type
      ;

primitive_type : 
        BOOLEAN 
      | CHAR 
      | BYTE 
      | SHORT 
      | INT 
      | LONG 
      | FLOAT 
      | DOUBLE
      | STRING
      | BARRIER
      | TIMER
      ;

named_type : 
        IDENTIFIER
     ;

array_type :
        primitive_type dims
      | channel_type dims
      | IDENTIFIER dims
      ;
 	
channel_type : 
	SHARED READ CHAN LT type GT
      | SHARED WRITE CHAN LT type GT 
      | SHARED CHAN LT type GT
      | CHAN LT type GT
      | CHAN LT type GT DOT READ
      | CHAN LT type GT DOT WRITE
      | SHARED CHAN LT type GT DOT READ
      | SHARED CHAN LT type GT DOT WRITE
      ;

// **************************************************
// 5.0 Packages
// **************************************************

compilation_unit : 
        package_declaration_opt import_declarations_opt type_declarations
      ;

package_declaration_opt :
        package_declaration
      | /* Epsilon */
      ;

package_declaration : 
        PACKAGE IDENTIFIER SEMICOLON
      ;

import_declarations_opt :
       import_declarations
      | /* Epsilon */
      ;

import_declarations :
        import_declarations import_declaration
      | import_declaration
      ;

import_declaration : 
        IMPORT IDENTIFIER SEMICOLON
      | IMPORT IDENTIFIER DOT MULT SEMICOLON
      | IMPORT IDENTIFIER DOT IDENTIFIER SEMICOLON
      ;

// **************************************************
// 6.0 Modifiers
// **************************************************

modifiers_opt :
        modifiers
      | /* Epsilon */
      ;

modifiers :
        modifiers modifier
      | modifier
      ;

modifier : 
        MOBILE 
      | CONST 
      | NATIVE 
      | PUBLIC 
      | PRIVATE 
      | PROTECTED 
      ;


// **************************************************
// 7.0 Constants and Variable Declarations
// **************************************************

constant_declaration : 
        CONST type IDENTIFIER EQ constant_expression SEMICOLON
      ;

variable_declarators : 
        variable_declarators COMMA variable_declarator
      | variable_declarator
      ;

variable_declarator : 
        variable_declarator_identifier
      | variable_declarator_identifier EQ variable_initializer
      ;

variable_declarator_identifier : 
        IDENTIFIER 
      | variable_declarator_identifier LBRACK RBRACK
      ;

variable_initializer : 
        array_initializer 
      | expression
      ;

// **************************************************
// 8.0 Arrays
// **************************************************

array_initializer : 
        LBRACE variable_initializers_opt RBRACE
      ;
variable_initializers_opt :
        variable_initializers 
      | /* Epsilon */
      ;

variable_initializers : 
        variable_initializers COMMA variable_initializer
      | variable_initializer
      ;

// **************************************************
// 9.0 Blocks and statements
// **************************************************

block_opt :
        block
      | /* Epsilon */
      ;

block : 
        LBRACE block_statements_opt RBRACE
      ;

block_statements_opt :
        block_statements
      | /* Epsilon */
      ;

block_statements :
        block_statements block_statement
      | block_statement
      ;

par_block : 
        PAR block
      | PAR ENROLL LPAREN barriers RPAREN block
      ;

barriers : 
        barriers COMMA IDENTIFIER
      | IDENTIFIER
      ;

block_statement : 
        local_variable_declaration SEMICOLON
      | statement
      ;

local_variable_declaration : 
        CONST type variable_declarators
      | type variable_declarators
      ;

statement : 
        statement_without_trailing_substatement
      | if_then_statement
      | if_then_else_statement
      | while_statement
      | for_statement
      | claim_statement
      | par_block
      | labeled_statement
      ;

statement_no_short_if :    
        statement_without_trailing_substatement
      | if_then_else_statement_no_short_if
      | while_statement_no_short_if
      | for_statement_no_short_if
      | claim_statement_no_short_if
      ;

statement_without_trailing_substatement :
        block
      | empty_statement
      | do_statement
      | barrier_sync_statement
      | timeout_statement	    
      | SEQ block
      | suspend_statement
      | expression_statement
      | break_statement
      | continue_statement
      | return_statement
      | switch_statement
      | skip_statement
      | stop_statement
      | IDENTIFIER DOT WRITE LPAREN expression RPAREN SEMICOLON
      | primary DOT WRITE LPAREN expression RPAREN SEMICOLON
      | alt_statement

      ;

// **************************************************
// 9.1 If statements
// **************************************************

if_then_statement :
        IF LPAREN expression RPAREN statement
      ;

if_then_else_statement :
	IF LPAREN expression RPAREN statement_no_short_if ELSE statement
      ;

if_then_else_statement_no_short_if :
        IF LPAREN expression RPAREN statement_no_short_if ELSE statement_no_short_if
      ;

// **************************************************
// 9.2 While/For/Do statement
// **************************************************

while_statement : 
        WHILE LPAREN expression RPAREN statement
      ;

while_statement_no_short_if :
	WHILE LPAREN expression RPAREN statement_no_short_if
      ;      

for_statement :
	FOR LPAREN for_init_opt SEMICOLON expression_opt SEMICOLON for_update_opt RPAREN statement
      | PAR FOR LPAREN for_init_opt SEMICOLON expression_opt SEMICOLON for_update_opt RPAREN statement
      ;

for_statement_no_short_if :
	FOR LPAREN for_init_opt SEMICOLON expression_opt SEMICOLON for_update_opt RPAREN statement_no_short_if
      | PAR FOR LPAREN for_init_opt SEMICOLON expression_opt SEMICOLON for_update_opt RPAREN statement_no_short_if
      ;

for_init_opt :
	for_init
      | /* Epsilon */    		
      ;

for_init :	
	statement_expressions  
      | local_variable_declaration 
      ;

for_update_opt :
	for_update
      | /* Epsilon */		
      ;

for_update :	
        statement_expressions 
      ;

statement_expressions :
	statement_expression 	
      | statement_expressions COMMA statement_expression
      ;

do_statement : 
        DO statement WHILE LPAREN expression RPAREN
      ;

// **************************************************
// 9.3 Claim Statement
// **************************************************

claim_statement : 
        CLAIM LPAREN channels RPAREN statement
      ;

claim_statement_no_short_if : 
        CLAIM LPAREN channels RPAREN statement_no_short_if
      ;

// this one is a little iffy!
channels :
        IDENTIFIER
      | channel_type IDENTIFIER EQ primary_no_new_array_or_mobile
      | chan_expression
      ;

// **************************************************
// 9.4 Empty Statement
// **************************************************

empty_statement : 
        SEMICOLON
      ;

// **************************************************
// 9.5 Barrier Synch/Timeout Statement
// **************************************************

barrier_sync_statement : 
        SYNC primary_no_new_array_or_mobile SEMICOLON
      ;

timeout_statement : 
        IDENTIFIER DOT TIMEOUT LPAREN expression RPAREN
      | primary DOT TIMEOUT LPAREN expression RPAREN
      ;

// **************************************************
// 9.6 Suspend Statement
// **************************************************

suspend_statement : 
        SUSPEND RESUME WITH LPAREN formal_parameter_list RPAREN SEMICOLON
      ;

// **************************************************
// 9.7 Expression Statement
// **************************************************

expression_statement :
        statement_expression SEMICOLON
      ;

statement_expression :
        assignment
      | pre_increment_expression
      | pre_decrement_expression
      | post_increment_expression
      | post_decrement_expression
      | invocation
      | primary DOT READ LPAREN block_opt RPAREN
      | IDENTIFIER DOT READ LPAREN block_opt RPAREN
      ;

labeled_statement : 
        IDENTIFIER COLON statement
       ;

// **************************************************
// 9.8 Break/Continue/Return Statement
// **************************************************

break_statement : 
        BREAK identifier_opt SEMICOLON
      ;

continue_statement : 
        CONTINUE identifier_opt SEMICOLON
      ;

identifier_opt :
        IDENTIFIER
      | /* Epsilon */
      ;

return_statement : 
        RETURN expression_opt SEMICOLON
      ;

// **************************************************
// 9.9 Switch Statement
// **************************************************

switch_statement : 
        SWITCH LPAREN expression RPAREN switch_block
      ;

switch_block : 
        LBRACE switch_block_statement_groups_opt RBRACE
      ;

switch_block_statement_groups_opt :
        switch_block_statement_groups 
      | /* Epsilon */			  
      ;

switch_block_statement_groups :
        switch_block_statement_group
      | switch_block_statement_groups switch_block_statement_group
      ;

switch_block_statement_group :
        switch_labels block_statements
      ;

switch_labels :
        switch_label			  
      | switch_labels switch_label 
      ;

switch_label :
        CASE constant_expression COLON
      | DEFAULT COLON
      ;

// **************************************************
// 9.10 Skip/Stop Statement
// **************************************************

stop_statement : 
        STOP SEMICOLON
      ;

skip_statement : 
        SKIP SEMICOLON
       ;

// **************************************************
// 9.11 Alt Statement
// **************************************************

alt_statement : 
        PRI ALT LBRACE alt_body RBRACE
      | ALT LBRACE alt_body RBRACE
      ;

alt_body : 
        alt_body alt_case 
      | alt_case
      ;

alt_case : 
        LPAREN expression RPAREN ANDAND guard COLON statement
      | guard COLON statement
      ;

guard : 
        left_hand_side EQ IDENTIFIER DOT READ LPAREN block_opt RPAREN
      | SKIP
      | timeout_statement
      ;

// **************************************************
// 10.0 Expressions
// **************************************************
//constants: array, record, protocol

primary :
        primary_no_new_array_or_mobile
      | array_creation_expression
      | mobile_creation
      | chan_comm_read_expression
      | chan_expression
      ;

primary_no_new_array_or_mobile :
        literal
      | LPAREN expression RPAREN
      | record_access
      | invocation
      | array_access
      ;

// **************************************************
// 10.1 Array Creation Expressions
// **************************************************a

array_creation_expression :
        NEW primitive_type dim_exprs dims_opt
      | NEW primitive_type dims array_initializer
      | NEW IDENTIFIER dim_exprs dims_opt
      | NEW IDENTIFIER dims array_initializer
      ;

dim_exprs :	
        dim_expr     	       	   
      | dim_exprs dim_expr	 
      ;

dim_expr : 
        LBRACK expression RBRACK
      ;

dims_opt :
        dims			
      | /* Epsilon */		
      ;

dims :  
        dims LBRACK RBRACK
      | LBRACK RBRACK
      ;

// **************************************************
// 10.2 Mobile Creation Expression
// **************************************************

mobile_creation : 
        NEW MOBILE IDENTIFIER  // maybe IDENTIFIER isn't good enough here
      ;

// **************************************************
// 10.3 Channel Expression/Channel Read Expression
// **************************************************

chan_expression :
        primary DOT READ
      | primary DOT WRITE
      | IDENTIFIER DOT READ
      | IDENTIFIER DOT WRITE
      ;

chan_comm_read_expression :
        primary DOT READ LPAREN block_opt RPAREN
      | IDENTIFIER DOT READ LPAREN block_opt RPAREN
      ;

// **************************************************
// 10.4 Structure Access
// **************************************************

record_access :
        primary DOT IDENTIFIER
      | IDENTIFIER DOT IDENTIFIER
      ;
	    
array_access :
        IDENTIFIER LBRACK expression RBRACK
      | primary_no_new_array_or_mobile LBRACK expression RBRACK
      ;

// **************************************************
// 10.5 Invocation Expression
// **************************************************

invocation :
        IDENTIFIER LPAREN argument_list_opt RPAREN
      ;

argument_list_opt :
        argument_list
      | /* Epsilon */             
      ;

argument_list :
        expression	
      | argument_list COMMA expression
      ;

// **************************************************
// 10.6 Other Expressions
// **************************************************

postfix_expression :
        primary
      | post_increment_expression
      | post_decrement_expression
      | IDENTIFIER
      ;

post_increment_expression :
        postfix_expression PLUSPLUS
      ;

post_decrement_expression :
        postfix_expression MINUSMINUS
      ;

unary_expression :
        pre_increment_expression
      | pre_decrement_expression
      | PLUS unary_expression
      | MINUS unary_expression
      | unary_expression_not_plus_minus 
      ;

pre_increment_expression :
        PLUSPLUS unary_expression       
      ;

pre_decrement_expression :
        MINUSMINUS unary_expression
      ;

unary_expression_not_plus_minus :
        postfix_expression
      | COMP unary_expression
      | NOT unary_expression
      | cast_expression
      ;
                  
cast_expression :
        LPAREN expression RPAREN unary_expression_not_plus_minus
      | LPAREN primitive_type RPAREN unary_expression
      ;

multiplicative_expression :
        unary_expression
      | multiplicative_expression MULT unary_expression
      | multiplicative_expression DIV unary_expression
      | multiplicative_expression MOD unary_expression
      ;

additive_expression : 
        multiplicative_expression
      | additive_expression PLUS multiplicative_expression
      | additive_expression MINUS multiplicative_expression
      ;
                  
shift_expression :
        additive_expression
      | shift_expression LSHIFT additive_expression
      | shift_expression RSHIFT additive_expression
      | shift_expression URSHIFT additive_expression
      ;
                       
relational_expression :
        shift_expression 
      | relational_expression LT shift_expression
      | relational_expression GT shift_expression
      | relational_expression LTEQ shift_expression
      | relational_expression GTEQ shift_expression
      ;
                 
equality_expression :
        relational_expression
      | equality_expression EQEQ relational_expression
      | equality_expression NOTEQ relational_expression
      ;
                
and_expression :
        equality_expression
      | and_expression AND equality_expression
      ;
                   
exclusive_or_expression :
        and_expression
      | exclusive_or_expression XOR and_expression
      ;
                  
inclusive_or_expression :
        exclusive_or_expression 
      | inclusive_or_expression OR exclusive_or_expression
      ;
                  
conditional_and_expression :
        inclusive_or_expression
      | conditional_and_expression ANDAND inclusive_or_expression
      ;
                  
conditional_or_expression :
        conditional_and_expression 
      | conditional_or_expression OROR conditional_and_expression
      ;
                  
conditional_expression :
        conditional_or_expression 
      | conditional_or_expression QUEST expression COLON conditional_expression
      ;
                  
assignment_expression :
        conditional_expression 
      | assignment
      ;
  
assignment :
        left_hand_side assignment_operator assignment_expression
      ;
              
assignment_operator :
        EQ
      | MULTEQ
      | DIVEQ
      | MODEQ
      | PLUSEQ
      | MINUSEQ
      | LSHIFTEQ
      | RSHIFTEQ
      | URSHIFTEQ
      | ANDEQ
      | XOREQ
      | OREQ
      ;
       
left_hand_side :
        IDENTIFIER
      | record_access
      | array_access
      ;  
        
expression_opt :
        expression
      | /* Epsilon */ 
      ;
  
expression :  
        assignment_expression
      ;

constant_expression :
        expression
      ;

// **************************************************
// 11.0 Literals
// **************************************************

literal :	
        INTEGER_LITERAL        
      | LONG_LITERAL           
      | FLOAT_LITERAL          
      | DOUBLE_LITERAL         
      | BOOLEAN_LITERAL        
      | STRING_LITERAL   
      | CHARACTER_LITERAL 
      | record_literal
      | protocol_literal
      ;

record_literal :
        IDENTIFIER LBRACE argument_list RBRACE
      ;

protocol_literal :
        IDENTIFIER LBRACE IDENTIFIER COLON argument_list RBRACE
      ;

%%
