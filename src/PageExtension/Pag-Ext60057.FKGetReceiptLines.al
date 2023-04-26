/// <summary>
/// PageExtension FK Get Receipt Lines (ID 60057) extends Record Get Receipt Lines.
/// </summary>
pageextension 60057 "FK Get Receipt Lines" extends "Get Receipt Lines"
{
    layout
    {
        addafter("No.")
        {
            field("Ref. GR No. Intranet"; Rec."Ref. GR No. Intranet")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }
    }
}
