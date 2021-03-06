function Main()
{
  try
  {
    // Enter your code here.
    RunApp();
    NewOrders();
    EditOrders();
    DeleteOrders();
    CloseApp(); 
  }
  catch(exception)
  {
    Log.Error("Exception", exception.description);
  }
}

function RunApp()
{
  TestedApps.Orders.Run();    // run Orders app
}

// Create new orders function
function NewOrders()           
{
  // Define variables 
  var product = Aliases.OrderForm.ProductNames;
  var quantity = Aliases.OrderForm.Quantity;
  var price = Aliases.OrderForm.Price;
  var discount = Aliases.OrderForm.Discount;
  var total = Aliases.OrderForm.Total;
  var order_date = Aliases.OrderForm.Date;
  var customer_name = Aliases.OrderForm.CustomerName;
  var street = Aliases.OrderForm.Street;
  var state = Aliases.OrderForm.State;
  var city = Aliases.OrderForm.City;
  var zip = Aliases.OrderForm.Zip;
  var visa = Aliases.OrderForm.Visa;
  var master_card = Aliases.OrderForm.MasterCard;
  var american_express = Aliases.OrderForm.AE;
  var card_number = Aliases.OrderForm.CardNo;
  var expiration_date = Aliases.OrderForm.ExpDate;   
  var drv = DDT.ExcelDriver(Project.Path + "\\Stores\\Files\\data.xls", "data", false); // create driver for Excel file reading
  var row = 0;                                                        // counter
  
  Log.AppendFolder("New orders");
   
  while (!DDT.CurrentDriver.EOF())                                    // create orders according to rows number in data.xls file
  { 
    row = row + 1; 
    Log.AppendFolder("Order " + row + " creation"); // create folder in Log and place logs into it
    
    //Log.PushLogFolder(Log.CreateFolder("111"));     
    NameMapping.sys.Orders.mainForm.MainMenu.Click("Orders|New order...");  // select "New order" in top menu 
     
    // Clear existing values from the inputs  
    price.Clear(); 
    discount.Clear();
    total.Clear();
    customer_name.Clear();  
    street.Clear();
    state.Clear();
    city.Clear();
    zip.Clear();
    card_number.Clear();   

    // Enter testing values from driver structure (data.xls file) into inputs   
    product.ClickItem(drv.Value("Product"));
    quantity.wValue = drv.Value("Quantity");
    price.Keys(drv.Value("Price"));
    discount.Keys(drv.Value("Discount"));
    total.Keys(drv.Value("Total"));
    order_date.wDate = drv.Value("Date");
    customer_name.Keys(drv.Value("Customer Name"));
    street.Keys(drv.Value("Street"));
    state.Keys(drv.Value("State"));
    city.Keys(drv.Value("City"));
    zip.Keys(drv.Value("Zip"));
  
    // Choose radio button depending on data in data.xls in "Card" column
    switch (drv.Value("Card"))
    {
    case "Visa":
      visa.Click();
      break;
    case "MasterCard":
      master_card.Click();
      break;
    case "American Express":
      american_express.Click();
      break;
    }
  
    card_number.Keys(drv.Value("Card No"));
    expiration_date.wDate = drv.Value("Expiration Date"); 

    Aliases.OrderForm.ButtonOK.ClickButton();   // click confirmation "Ok" button 
    
    // Compare entered value and value in the orders list 
    aqObject.CompareProperty(Aliases.OrdersView.wSelectedItems, cmpEqual, drv.Value("Customer Name"), true);
    drv.Next();               // choose next row with data in data.xls  
    Log.PopLogFolder();       // step up from current Log folder
  }
  
  DDT.CloseDriver(drv.Name);  // close driver
  Log.PopLogFolder();
}

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

// Delete orders function
function DeleteOrders()
{
  var row = 0;                                                      // counter
  
  Log.AppendFolder("Delete orders");                                // create folder in Log and place logs into it
  while (Aliases.OrdersView.wItemCount != 0)                        // until there are orders
  { 
    row = row + 1;  
    Log.AppendFolder("Order " + row + " deleting");                 // create folder in Log and place logs into it
    Aliases.OrdersView.ClickItem(Aliases.OrdersView.TopItem.Index); // choose top order     
    NameMapping.Sys.Orders.MainForm.ToolBar.ClickItem(6);           // click "Delete" button on the toolbar    
    NameMapping.Sys.Orders.dlgConfirmation.btnYes.ClickButton();    // delete confirmation
    Log.PopLogFolder();                                             // step up from current Log folder  
  }
  Log.PopLogFolder();                                               // step up from current Log folder 
}

// Close app function
function CloseApp()
{
  NameMapping.Sys.Orders.MainForm.Close();                          // close Orders app  
  NameMapping.Sys.Orders.dlgConfirmation.btnNo.ClickButton();       // exit without saving confirmation
  Log.Message("App exit");
}