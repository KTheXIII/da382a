# Poll-attitude documentation
_Written by Marcus Linné, will be updated further as soon as I have more "finalized" code to go through._

## __Primary methods__

### **`setup-poll-attitude`**
Creates the matrix for each attitude plane. This happens whenever a voter is born/created.

Sets up two matrices, message-matrix and conviction-matrix. 

`message-matrix` is used to store the amount of incoming messages for a political position.

`conviction-matrix` is used to store the agents political conviction, which is a value that indicates 
how strongly the agent believes in a political position.

### **`update-poll-attitude`**
**Explaination:**
TODO, Far from finished documentation.
    
This method is used to update the `conviction-plane` each month for the agent using `conviction-plane` and messages 
handled in the `message-plane`


### **`process-messages(x, y)`**
**INPUT:**    

`x` The x-value in the attitude plane from the message processed.

`y` The y-value in the attitude plane from the message processed.

This method takes the `x` and `y` values from the attitude plane that is included in the messages that are proecessed.

Adds a value on the message-matrix on the position x,y


## **Utility functions**

### **`matrix-insert(x, y, value)`**
Inserts a value in a mtrix on coordinate x,y 


### **`matrix-create(rows, column, value)`**
**Explaination:**

This method returns/reports an matrix with a size based on `rows`, `column` that is filled with `value`:s. 


### **`matrix-query(matrix, x, y)`**
**Explaination:**

Utility function  to get the value of a coordinate in a matrix
