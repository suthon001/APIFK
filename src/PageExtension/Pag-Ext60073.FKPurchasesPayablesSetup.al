/// <summary>
/// PageExtension FK Purchases & Payables Setup (ID 60073) extends Record Purchases & Payables Setup.
/// </summary>
pageextension 60073 "FK Purchases & Payables Setup" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("TPP Purchase Billing Nos."; Rec."TPP Purchase Billing Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Purchase Billing Nos. field.';
            }
        }
    }
}
