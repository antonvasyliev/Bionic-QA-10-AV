// Close app function
function CloseApp()
{
  NameMapping.Sys.Orders.MainForm.Close();                          // close Orders app  
  NameMapping.Sys.Orders.dlgConfirmation.btnNo.ClickButton();       // exit without saving confirmation
  Log.Message("App exit");
}