import java.util.regex.Pattern;

int W = 360-1;
int H = 340;

PFont font;

char oper;
boolean is_oper = false;
boolean is_comma = false;
boolean is_minus = false;

boolean is_neg = false;
int neg_ind = -1;

// If there is a +, x, or /, set is_oper to true otherwise set it to false
void SetIsOper(Label l)
{
  if (l.text.indexOf('+') != -1) is_oper = true;
  else if (l.text.indexOf('x') != -1) is_oper = true;
  else if (l.text.indexOf('/') != -1) is_oper = true;
  else is_oper = false;
}

// Check if c is a +, -, x or /
boolean CheckOperator(char c)
{
  return c == '+' || c == '-' || c == 'x' || c == '/';
}

// If c is not an operator(+, -, x, /) or a dot, it must be a number
boolean CheckNumber(char c)
{
  if (!CheckOperator(c) && c != '.') return true;
  return false;
}

// Split a string(ex: 10x20 -> str="10x20", c='x'; return String[] : ["10", "20"])
String[] parseStr(String str, char c)
{
  return str.split(Pattern.quote(String.valueOf(c)));
}

// Check if a double is an integer(ex: 2.5 -> false, 3.0 -> true)
boolean isInteger(double f)
{
  int i = (int)f;
  
  double temp = f - i;
  
  if (temp > 0) return false;
  return true;
}

/* Class Color */
public class Color
{
  int r, g, b; // reg, green and blue
  
  // Constructor
  public Color(int r, int g, int b)
  {
    this.r = r;
    this.g = g;
    this.b = b;
  }
}

/* Enum ButtonTypes */
public enum ButtonTypes
{
  NUMBER_BUTTON, // Number button
  OPERATOR_BUTTON, // +, -, x, /
  /* Other button types */
  DELETE_BUTTON, // delete button
  CLEAR_BUTTON, // clear all button
  COMMA_BUTTON, // comma button
  EQUAL_BUTTON, // equal button
  NEG_BUTTON, // "-n" button
}

/* Class label */
class Label
{
  String text; // text of the label
  int x, y, w, h;  // position and size
  int textSize; // the size of the text
  Color c; // color of the rectangle
  
  // Constructor
  public Label(int x, int y, int w, int h, Color c, String text, int textSize)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    this.text = text;
    this.textSize = textSize;
  }
  
  // This function draws the label
  public void Draw()
  {
    fill(c.r, c.g, c.b); // fill the rectangle with a chosen color
    rect(x, y, w, h); // draw a rectangle
    fill(0, 0, 0); // fill the text with black color
    textAlign(RIGHT, CENTER); // align the text
    text(text, w+x-5, ((y + (y + h)) / 2) - 5); // draw the text
  }
}

/* Class Button */
public class Button
{
  // Variables
  String text; // text on the button
  int x, y, w, h; // x and y coordinates and width and height
  Color button_color; // the color of the button
  Color pressed_color; // the color of the pressed button
  Color entered_color; // when mouse enter the button, the color becomes a little darker
  ButtonTypes type; // the type of the button
  
  Color current_color; // the current color of the button
  boolean pressed; // when the button is pressed, pressed = true otherwise false
  
  // Constructor
  public Button(int x, int y, int w, int h, String text, Color button_color, ButtonTypes type)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text = text;
    this.button_color = button_color;
    this.pressed_color = new Color(button_color.r - 30, button_color.g - 30, button_color.b - 30);
    this.entered_color = new Color(button_color.r - 15, button_color.g - 15, button_color.b - 15);
    this.type = type;
    
    this.current_color = button_color;
    this.pressed = false;
  }
  
  // This function draws the button
  public void Draw()
  {
    if (CheckEntered() && !pressed)
      current_color = entered_color;
    else if (pressed)
      current_color = pressed_color;
    else
      current_color = button_color;
    
    fill(current_color.r, current_color.g, current_color.b);
    rect(x, y, w, h);
    fill(0, 0, 0);
    textFont(font);
    textAlign(CENTER, CENTER);
    text(text, (x + (x + w)) / 2, ((y + (y + h)) / 2) - 5);
  }
  
  // This function does what each type of button does when pressed
  public void Press(Label l)
  {
    if (type == ButtonTypes.NUMBER_BUTTON)
    {
      if (pressed && l.text.length() < 26)
      {
        l.text += text; // add the text of a number button(1, 2, 3, 4, 5, 6, 7, 8, 9, 0)
      }
    } else if (type == ButtonTypes.DELETE_BUTTON)
    {
      if (pressed)
      {
        if (l.text.length() <= 1) // if in "l", there is only one character
        {
          if (is_neg && neg_ind == l.text.length()-1) // if the character we were going to delete is a minus but a "-n"
          {
            is_neg = false;
          }
                   
          l.text = ""; // if there is only one character in "l", we simply empty him
          return;
        }
        
        if (is_neg && neg_ind == l.text.length()-1) // if the character we were going to delete is a minus but a "-n"
        {
          is_neg = false;
        }
        
        if (l.text.charAt(l.text.length()-1) == '-' && is_minus) // if the last character is a minus operator
        {
          is_minus = false;
          is_oper = false;
        }
        
        l.text = l.text.substring(0, l.text.length()-1); // delete the last character
      }
    } else if (type == ButtonTypes.CLEAR_BUTTON)
    {
      if (pressed)
      {
        l.text = ""; // clear all and tell that there aren't nor minus, nor operator(+, -, x, /), nor comma, nor "-n"
        is_minus = false;
        is_oper = false;
        is_comma = false;
        is_num1 = false;
        is_neg = false;
      }
    } else if (type == ButtonTypes.OPERATOR_BUTTON)
    {
      if (pressed && !is_oper && l.text.length() > 0 && l.text.length() < 26 && l.text.charAt(l.text.length()-1) != '.' && text.charAt(0) != '-') // For all operators except minus
      {
        if (CheckOperator(text.charAt(0)) && l.text.length() > 0)
        {
          NUM1 = Double.parseDouble(l.text); // Convert String to Double
          is_num1 = true;
          oper = text.charAt(0); // Set oper to the operator button that was pressed
          is_oper = true;
          l.text += text; // Add operator to the screen
          is_comma = false;
          is_neg = false;
        }
      } else if (pressed && l.text.length() > 0 && !is_minus && !is_oper && l.text.length() < 26 && l.text.charAt(l.text.length()-1) != '.' && text.charAt(0) == '-') // For only minus
      {
        if (CheckOperator(text.charAt(0)) && l.text.length() > 0)
        {
          NUM1 = Double.parseDouble(l.text);
          is_num1 = true;
          oper = text.charAt(0);
          is_oper = true;
          is_minus = true;
          l.text += text;
          is_comma = false;
        }
      }
    } else if (type == ButtonTypes.EQUAL_BUTTON)
    {
      if (pressed)
      {
        if (is_num1 && !CheckOperator(l.text.charAt(l.text.length()-1)) && l.text.charAt(l.text.length()-1) != '.')
        {
          String[] strs = parseStr(l.text, oper); // split l.text by oper(ex: str: 10/20, oper: / -> [10, 20])
          NUM2 = Double.parseDouble(strs[strs.length-1]); // this takes the last element in strs(ex: [10, 20] --> it will take 20) and convert it to double
          
          double res = 0; // result
          if (oper == '+')
          {
            res = NUM1 + NUM2;
          } else if (oper == '-')
          {
            res = NUM1 - NUM2;
          } else if (oper == 'x')
          {
            res = NUM1 * NUM2;
          } else if (oper == '/')
          {
            res = NUM1 / NUM2;
          }
          
          if (isInteger(res)) // if the result is an integer(ex: 5.0)
          {
            l.text = String.valueOf(Math.round(res)); // We don't show the ".0" just "5"
          } else
          {
            l.text = String.valueOf(Double.toString(res)); // Otherwise we show the result with extra precision
          }
          
          is_oper = false;
          is_comma = false;
          
          if (res > 0) is_neg = false; // only if the result is positive, we can negate the result otherwise we can't
        }
      }
    } else if (type == ButtonTypes.COMMA_BUTTON)
    {
      if (pressed && l.text.length() > 0 && l.text.length() < 26)
      {
        if (CheckNumber(l.text.charAt(l.text.length()-1)) && !is_comma)
        {
          l.text += '.'; // add a dot
          is_comma = true; // make it true so we can't add more dots
        }
      }
    } else if (type == ButtonTypes.NEG_BUTTON)
    {
      if (pressed && !is_neg && !is_minus && l.text.length() < 26)
      {
        l.text += '-'; // add a minus
        is_neg = true;
        
        neg_ind = l.text.length()-1; // set the index to know where the negative sign is
      }
    }
  }
  
  /* Check if mouse entered the button */
  public boolean CheckEntered()
  {
    if (mouseX >= x && mouseX < (x + w) && mouseY >= y && mouseY < (y + h)) return true;
    return false;
  }
}

double NUM1 = 0, NUM2 = 0;
boolean is_num1 = false;

int count_btns = 10;
Button[] num_btns = new Button[count_btns];
Button del_button, clear_button;

int count_opers = 4;
char[] oper_chars = {'+', '-', 'x', '/'};
Button[] oper_btns = new Button[count_opers]; // +, -, x and / buttons

Button comma_btn; // the comma button
Button equal_btn; // the equal button
Button neg_btn; // the "-n" button

Label textBox;
Label hist;

void setup()
{
  size(360, 340);
  background(155);
  
  font = createFont("Source Code Pro", 22.4);
  
  textBox = new Label(0, 0, W, 50, new Color(240, 240, 240), "", 15);
  
  /* 1 to 9 buttons */
  int X = 10, x = X;
  int Y = 60, y = Y;
  int i;
  for (i = 0; i < count_btns-1; i++)
  {
    num_btns[i] = new Button(x, y, 60, 60, String.valueOf(i+1), new Color(220, 220, 220), ButtonTypes.NUMBER_BUTTON);
    
    if (i == 2 || i == 5 || i == 8)
    {
      y += 70;
      x = X;
    } else {
      x += 70;
    }
  }
  /* end of for loop */
  
  // Zero Button
  num_btns[i] = new Button(x, y, 130, 60, String.valueOf(i-9), new Color(220, 220, 220), ButtonTypes.NUMBER_BUTTON);
  // Delete and clear button
  del_button = new Button(220, 60, 60, 60, "DEL", new Color(220, 220, 220), ButtonTypes.DELETE_BUTTON);
  clear_button = new Button(290, 60, 60, 60, "CLR", new Color(220, 220, 220), ButtonTypes.CLEAR_BUTTON);
  
  // Operator buttons
  X = 220; Y = 130; x = X; y = Y;
  for (i = 0; i < count_opers; i++)
  {
    oper_btns[i] = new Button(x, y, 60, 60, String.valueOf(oper_chars[i]), new Color(220, 220, 220), ButtonTypes.OPERATOR_BUTTON);
    if (i == 1)
    {
      y += 70;
      x = X;
    } else {
      x += 70;
    }
  }
  
  comma_btn = new Button(150, 270, 60, 60, ",", new Color(220, 220, 220), ButtonTypes.COMMA_BUTTON);
  equal_btn = new Button(220, 270, 60, 60, "=", new Color(220, 220, 220), ButtonTypes.EQUAL_BUTTON);
  neg_btn = new Button(290, 270, 60, 60, "-n", new Color(220, 220, 220), ButtonTypes.NEG_BUTTON);   
}

void draw()
{
  background(255, 255, 255);
  
  textBox.Draw();
  
  SetIsOper(textBox);
  
  for (int i = 0; i < count_btns; i++)
  {
    num_btns[i].Draw();
  }
  del_button.Draw();
  clear_button.Draw();
  
  for (int i = 0; i < count_opers; i++)
  {
    oper_btns[i].Draw();
  }
  
  comma_btn.Draw();
  equal_btn.Draw();
  neg_btn.Draw();
}

void mousePressed()
{
  if (mouseButton == LEFT)
  {
    for (int i = 0; i < count_btns; i++) 
    {
      if (num_btns[i].CheckEntered())
      {
        num_btns[i].pressed = true;
        num_btns[i].Press(textBox);
      }
    }
    
    if (del_button.CheckEntered())
    {
      del_button.pressed = true;
      del_button.Press(textBox);
    }
    if (clear_button.CheckEntered())
    {
      clear_button.pressed = true;
      clear_button.Press(textBox);
    }
    
    for (int i = 0; i < count_opers; i++)
    {
      if (oper_btns[i].CheckEntered())
      {
        oper_btns[i].pressed = true;
        oper_btns[i].Press(textBox);
      }
    }
    
    if (comma_btn.CheckEntered())
    {
      comma_btn.pressed = true;
      comma_btn.Press(textBox);
    }
    if (equal_btn.CheckEntered())
    {
      equal_btn.pressed = true;
      equal_btn.Press(textBox);
    }
    if (neg_btn.CheckEntered())
    {
      neg_btn.pressed = true;
      neg_btn.Press(textBox);
    }
  }
}

void mouseReleased()
{
  if (mouseButton == LEFT)
  {
    for (int i = 0; i < count_btns; i++)
    {
      if (num_btns[i].pressed)
      {
        num_btns[i].pressed = false;
      }
    }
      
    del_button.pressed = false;
    clear_button.pressed = false;
      
    for (int i = 0; i < count_opers; i++)
    {
      if (oper_btns[i].pressed)
      {
        oper_btns[i].pressed = false;
      }
    }
    
    comma_btn.pressed = false;
    equal_btn.pressed = false;
    neg_btn.pressed = false;
  }
}
