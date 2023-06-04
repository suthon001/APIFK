/// <summary>
/// Page API Log Entry (ID 60053).
/// </summary>
page 60053 "FK API Log Entry"
{
    ApplicationArea = All;
    Caption = 'API Log Entry';
    PageType = List;
    SourceTable = "FK API Log";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = History;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    CardPageId = "FK APi Log Card";
    DataCaptionExpression = StrSubstNo(DataCaptionLbl, rec."Page Name", rec."Document No.");
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = all;
                }
                field("Method Type"; Rec."Method Type")
                {
                    ToolTip = 'Specifies the value of the Method Type field.';
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = all;
                    Caption = 'Table ID';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                    ApplicationArea = all;
                }
                field("Page Name"; Rec."Page Name")
                {
                    ToolTip = 'Specifies the value of the Page Name field.';
                    ApplicationArea = all;
                }
                field("Is Manual"; Rec."Is Manual")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Is Manual field.';
                }
                field("Interface By"; Rec."Interface By")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Interface By field.';

                }
                field("Date Time"; Rec."Date Time")
                {
                    ToolTip = 'Specifies the value of the Date Time field.';
                    ApplicationArea = all;
                }
            }
        }
    }
    var
        DataCaptionLbl: Label '%1:%2', Locked = true;
}
