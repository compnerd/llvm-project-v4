//===-- main.cpp ------------------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

template <int Arg>
class TestObj
{
public:
  int getArg()
  {
    return Arg;
  }
};

<<<<<<< HEAD
=======
//----------------------------------------------------------------------
// Define a template class that we can specialize with an enumeration
//----------------------------------------------------------------------
enum class EnumType
{
    Member,
    Subclass
};

template <EnumType Arg> class EnumTemplate;
                                          
//----------------------------------------------------------------------
// Specialization for use when "Arg" is "EnumType::Member"
//----------------------------------------------------------------------
template <>
class EnumTemplate<EnumType::Member> 
{
public:
    EnumTemplate(int m) :
        m_member(m)
    {
    }

    int getMember() const
    {
        return m_member;
    }

protected:
    int m_member;
};

//----------------------------------------------------------------------
// Specialization for use when "Arg" is "EnumType::Subclass"
//----------------------------------------------------------------------
template <>
class EnumTemplate<EnumType::Subclass> : 
    public EnumTemplate<EnumType::Member> 
{
public:
    EnumTemplate(int m) : EnumTemplate<EnumType::Member>(m)
    {
    }    
};

>>>>>>> origin/master
int main(int argc, char **argv)
{
  TestObj<1> testpos;
  TestObj<-1> testneg;
<<<<<<< HEAD
  return testpos.getArg() - testneg.getArg(); // Breakpoint 1
=======
  EnumTemplate<EnumType::Member> member(123);
  EnumTemplate<EnumType::Subclass> subclass(123*2);
  return testpos.getArg() - testneg.getArg() + member.getMember()*2 - subclass.getMember(); // Breakpoint 1
>>>>>>> origin/master
}
