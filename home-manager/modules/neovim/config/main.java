package test;

public class Person {
  private String introduce() {
    System.out.println("some text1");
  }

  public static void main(String[] args) {
    new Person().introduce();
  }
}
