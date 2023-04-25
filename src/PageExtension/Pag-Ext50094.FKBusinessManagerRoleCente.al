/// <summary>
/// PageExtension FK Business Manager Role Cente (ID 50094) extends Record Business Manager Role Center.
/// </summary>
pageextension 50094 "FK Business Manager Role Cente" extends "Business Manager Role Center"
{
    actions
    {
        addafter("<Page Purchase Orders>")
        {
            action("GoodReceiptNote")
            {
                ApplicationArea = Suite;
                Caption = 'Good Receipt Note';
                Image = Document;
                RunObject = Page "FK Good ReceiptNote List";
                ToolTip = 'Good ReceiptNote List';
            }
        }
    }
}
