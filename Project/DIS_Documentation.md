# Poll-attitude documentation
_Written by Marcus Linné, will be updated further as soon as I have more "finalized" code to go through._

## __Primary methods__

### **`setup-poll-attitude`**
Creates the matrix for each attitude plane. This happens whenever a voter is born/created.

Sets up an attitude plane "heatmap" which is an 3*5 matrix. When doing this, it creates 2 beliefs called `conviction-plane` and `message-plane`.


### **`update-poll-attitude`**
**Explaination:**
TODO, Far from finished documentation.
    
This method is used to update the attitude plane each month for the agent using "attitude-plane" and messages handled in the "message-plane" 


### **`process-messages(x, y)`**
**INPUT:**    

`x` The x-value in the attitude plane from the message processed.

`y` The y-value in the attitude plane from the message processed.

This method takes the `x` and `y` values from the attitude plane that is included in the messages that are proecessed.


## **Secondary methods**

### **`matrix-insert(x, y)`**
TODO


### **`matrix-create(rows, column, value)`**
**Explaination:**

This method returns/reports an matrix with a size based on `rows`, `column` that is filled with `value`:s. 


### **`matrix-query(matrix, x, y)`**
**Explaination:**
