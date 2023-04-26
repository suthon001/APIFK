/// <summary>
/// PageExtension FK Posted Purchase Receipt (ID 60055) extends Record Posted Purchase Receipt.
/// </summary>
pageextension 60055 "FK Posted Purchase Receipt" extends "Posted Purchase Receipt"
{
    layout
    {
        addlast(General)
        {
            field("Ref. GR No. Intranet"; Rec."Ref. GR No. Intranet")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }
    }
}
