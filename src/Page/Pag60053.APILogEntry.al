page 60053 "API Log Entry"
{
    ApplicationArea = All;
    Caption = 'API Log Entry';
    PageType = List;
    SourceTable = "API Log";
    UsageCategory = History;
    InsertAllowed = false;
    ModifyAllowed = false;
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
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = all;
                }
                field("Page Name"; Rec."Page Name")
                {
                    ToolTip = 'Specifies the value of the Page Name field.';
                    ApplicationArea = all;
                }
                field("Last Error"; Rec."Last Error")
                {
                    ToolTip = 'Specifies the value of the Last Error field.';
                    ApplicationArea = all;
                }
                field("Json Msg."; Rec."Json Msg.")
                {
                    ToolTip = 'Specifies the value of the Json Msg. field.';
                    ApplicationArea = all;
                }
                field("Date Time"; Rec."Date Time")
                {
                    ToolTip = 'Specifies the value of the Date Time field.';
                    ApplicationArea = all;
                }
            }
        }
    }
}
