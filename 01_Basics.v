

(*

1. Basics:


Let's start avoiding the unique parts of coq. The Coq system has the equivlaent of many things you might be used to in a functional programming language like OCaml or Haskell.

First off, part of the coolness of coq is the interactivity of the tools. It is sort of like a REPL on steroids. It is absolutely vital you follow along with an interactive mode in an editor.
There are a couple options. 


CoqIDE comes along with coq.
Proof General for Emacs
VSCoq for VSCode

They all have the ability to step through code via hotkey bindings. You need to learn those.
Proof General execute lines with Ctrl+C + Enter
VSCoq is Ctrl+Alt+ArrowKeys, (Ctrl + Command + ArrowKeys on Mac)

 *)


(*

By default Coq imports a prelude. 


A decent basic overview of what is in the standard library and what is imported by default

https://coq.inria.fr/refman/language/coq-library.html

You can find a list of default built in data types here
 https://coq.inria.fr/library/Coq.Init.Datatypes.html

This includes the following (hopefully) familiar friends:
bool, list, option, sum, prod, nat, unit, Empty_set, comparison, identity

In Haskell these would be
Bool, [], Maybe, Either, Tuple, ? I don't think the standard library has a Nat , (), Void, Ordering, 

There are also some default functions available for these data types. More functions are available upon extra importing

The interactive mode of coq has many commands. These start with capital latters and are called Vernacular commands. The terminology Vernacular is why coq files are called .v files.

About and Print will tell us information about something. Print tends to show the actual definitions.
You can also ask about operators by putting them in quotes

Locate 


*)

About bool.
About prod.
About list.


(* You can compute values by calling Compute or by Eval compute, which is slightly different. Eval has more options   *)


Compute andb true false. (* You can run code by using the Compute vernacular. *)
Compute 1 + 1.
Compute 2 * 3.
Compute 5 - 2. 
Compute 3 - 5. (* subtraction is defined to be 0 if it would be negative *)
Print "-". 
Compute app (cons 1 nil) (cons 2 (cons 3 nil)). (* app is the list append function *)
Print app. (* Print can give you a more complete infromation. For example the code implementing the function *)


(* You can ask for the type of something by Check *)

(* What is the nat equality operator? I don't know. But I do know what there type signature is, so I can use the Search vernacular to find functions in the context. Search is very powerful and useful *)

Search ( nat -> nat -> bool).
Compute Nat.eqb 1 2.
Compute Nat.div 6 5. (* rounds down *)

(* We can also search for anything that involves list *)
Search list.
Search bool.
Search bool -> bool -> _.
Search ?m = ?m.
Search (list ?m -> list ?m).
SearchRewrite (O + _).
Search list.


(* Basic bool functions: 
Basic list functions:
Basic nat functions:


*)


(* 
Coq has a special mechanism to support notations. One that is useful and not on by default is list notation

Locate vernacular can be helpful.

Require loads a library qualified whereas Import brings its definitions into scope. Require Import does both.
For example 
Require Vector.
means we have to call Vector.cons, where Require Import Vector, means we can just call cons.



Starting Notations

 *)

Require Import Lists.List.
Import ListNotations.
Compute app [ 1 ] [ 2 ; 3 ].



About hd.

Compute hd 0 (cons 1 nil).
Compute (tl ([ 1 ; 2 ; 3])).
Compute hd 0 [ 1 ; 2 ; 3]. (* head takes a default value to make it total *)
Compute hd 0 [].


(* New names can be made via the Definition vernacular command. 
Definition has a couple different forms. You can bind names to input parameters to functions by putting them before the colon

 *)
Definition double (x : nat) : nat := 2 * x.
Compute double 3.

(*  Defining double using a lambda instead. This is the same as the above. *)
Definition double'' : nat -> nat := fun (x : nat) => 2 * x.

(* Sometimes coq can infer all the types so you don't need to annotate them. Often you want to though. *)

Definition double' x := 2 * x.
Check double'.
Compute double' 3.

(* Definiion can also be used to define types. As a dependently typed language, types and values are not kept apart. *)

(* Haskell equivalent: type BoolList = [Bool] *)

Definition boollist := list bool.





(* The standard in Haskell and ocaml is to allow type signatures to be inferred or to place them on seperate lines. In Coq, this is not how it goes. The pieces are typed in place.  *)

Inductive rgb : Type :=
  | red : rgb
  | green : rgb
  | blue : rgb.

  (* A pure enumeration type can get by with very little annotation *)
Inductive rgb' :=
  | red'
  | green'
  | blue'.


Inductive mycont : Type := 
  | IsNat (x : nat) 
  | IsBool (b : bool).

(* From a Haskell perspective, type definitions are most similar to GADT syntax *)
Inductive mycont' : Type := 
  | IsNat' : nat -> mycont' 
  | IsBool' : bool -> mycont'.


About rgb'.
About rgb.

(* Inferred parameters are given in braces {}. When using this function, you can chooce to explicity include these arguments or leave them implciit *)

Definition myid {A : Type} x : A := x.
Compute myid 3.
(*  Adding @ makes all arguments explcit *)
Compute @myid nat 3.
(* Particular arguments can be supplied by name *)
Compute myid (A:=nat) 3.

(* The equivalent of a type alias in Haskell 
type NatList = [Nat]
*)
Definition natlist :=  list nat.


Compute pair 1 2.
About pair.
About sum.


(* Pattern matching happens in explicit match statements, the equivalent of a Haskell "case". *)
Definition andb (b1 : bool) (b2 : bool) : bool :=
  match b1 with
    | true => b2
    | false => false
  end.


(* You can pattern match on multiple things at the same time. This is desugared into matching on b1 then matching on b2 *)

Definition andb' (b1 : bool) (b2 : bool) : bool :=
  match b1, b2 with
    | true, true => true
    | _, _ => false
  end.


(* Pattern matching allows some extra type annotation. It feels overblown at the moment, but Coq's type inference is far more finicky than other languages. 

match x as y in () return 
  |
  |
end

Coq does not do nearly as much as you'd think in this match statement if you are used to Haskell GADT's or Agda/Idris.

*)


About andb.

(* Recursive definitions need to be declared with Fixpoint.

*)


Fixpoint factorial (x : nat) : nat :=
  match x with
   | 0 => 1
   | S n => x * (factorial n)
  end.

Compute factorial 5.


Search list.

About fold_left.
Compute fold_left (fun x y => x + y) [1 ; 2 ; 3] 0.



(* Extraction *)

Require Coq.extraction.Extraction.
Extraction Language Haskell.
Recursive Extraction app.



Extraction "app.hs" app. (* extract to a file *)
(* You can inspect the Haskell equivalent *) 
Extraction app.
Recursive Extraction app.
Print rev'.



About app.
(*



    *)

  
(*
Inductive bool : Type :=
  | true : bool
  | false : bool.
*)

(* Record command

 *)



Compute andb true true.
Compute andb false true.

Check andb.

(*
The prod type definition looks like this

Inductive prod (A : Type) (B : Type) : Type :=
  | pair : A -> B -> prod A B.
*)


Check pair.
Compute pair nat bool 3 true.

(*
https://coq.inria.fr/refman/proof-engine/vernacular-commands.html
                                                     *) 

About pair.
Search nat.
Search bool.



Section mysection.
  Variable T : Set.
  Variable S : Set.
  Definition myfst () := 
End mysection.


(*

https://stackoverflow.com/questions/29322534/coq-prop-versus-set-in-typen

Prop, Type, Set

*)




(*
false: bool
true: bool
andb: bool -> bool -> bool
bool_rect: forall P : bool -> Type, P true -> P false -> forall b : bool, P b
bool_ind: forall P : bool -> Prop, P true -> P false -> forall b : bool, P b
                                                                           bool_rec: forall P : bool -> Set, P true -> P false -> forall b : bool, P b



                                                                                       

                                                              *)

(* 

Not sure we should cover these

Setoid


Floating point numbers are rather difficult to reason about precisely. A replacement for some purposes is to use rational numbers
QArith

Maps and Sets - a pain in the ass.

Vectors

Strings

*)

(*
Require Import Coq.Arith.Arith.
Require Import Coq.Bool.Bool.
Require Export Coq.Strings.String.
Require Import Coq.Logic.FunctionalExtensionality.
Require Import Coq.Lists.List.
Import ListNotations.





*)




