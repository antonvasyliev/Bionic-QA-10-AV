// Edit orders function
function EditOrders()                           
{ 
  // Define variables  
  var customer_name = Aliases.OrderForm.CustomerName;                            
  var row = 1;                                                                  // counter
  
  Log.AppendFolder("Edit orders");                                              // create folder in Log and place logs into it
  Log.AppendFolder("Order " + row + " editing");                                // create folder in Log and place logs into it
  Aliases.OrdersView.DblClickItem(Aliases.OrdersView.TopItem.Index);            // DblClick on the top item in the orders list opens "Edit order" window   
  customer_name.Keys("Customer_Name" + (Aliases.OrdersView.TopItem.Index + 1)); // type new name (name has a "Customer_Name#" mask)  
  Aliases.OrderForm.ButtonOK.ClickButton();                                     // edit confirmation through button "Ok" clicking
  
  // Compare new entered value and value in the orders list 
  aqObject.CompareProperty(Aliases.OrdersView.wSelectedItems, cmpEqual, "Customer_Name" + (Aliases.OrdersView.TopItem.Index + 1), true);  
  Log.PopLogFolder();                                                           // step up from current Log folder
  
  // Until there are unchecked orders 
  while (Aliases.OrdersView.wItemCount - 1 != Aliases.OrdersView.FocusedItem.Index)
  { 
    row = row + 1;
    Log.AppendFolder("Order " + row + " editing");                              // create folder in Log and place logs into it   
    //customer_name.Clear();                                                    // clear existing value from the "Customer name" input       
    Aliases.OrdersView.DblClickItem(Aliases.OrdersView.FocusedItem.Index + 1);        // go down through the list   
    customer_name.Keys("Customer_Name" + (Aliases.OrdersView.FocusedItem.Index + 1)); // type new name (name has a "Customer_Name#" mask)     
    Aliases.OrderForm.ButtonOK.ClickButton();                                   // edit confirmation through button "Ok" clicking  
    
    // Compare new entered value and value in the orders list
    aqObject.CompareProperty(Aliases.OrdersView.wSelectedItems, cmpEqual, "Customer_Name" + (Aliases.OrdersView.FocusedItem.Index + 1), true);
    Log.PopLogFolder();                                                         // step up from current Log folder     
  }
  Log.PopLogFolder();                                                           // step up from current Log folder 
}