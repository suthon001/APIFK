/// <summary>
/// Page Export Template Subform (ID 60052).
/// </summary>
page 60052 "Export Template Subform"
{
    Caption = 'Export Template Subform';
    PageType = ListPart;
    SourceTable = "API Setup Line";
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Include; Rec.Include)
                {
                    ToolTip = 'Specifies the value of the Include field.';
                    ApplicationArea = all;
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the Field No. field.';
                    ApplicationArea = all;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ToolTip = 'Specifies the value of the Field Name field.';
                    ApplicationArea = all;
                }
                field("Field Type"; Rec."Field Type")
                {
                    ToolTip = 'Specifies the value of the Field Type field.';
                    ApplicationArea = all;
                }
                field("Service Name"; Rec."Service Name")
                {
                    ToolTip = 'Specifies the value of the Service Name field.';
                    ApplicationArea = all;
                }
                field("Service Name 2"; Rec."Service Name 2")
                {
                    ToolTip = 'Specifies the value of the Service Name 2 field.';
                    ApplicationArea = all;
                }
                field(Lenth; Rec.Lenth)
                {
                    ToolTip = 'Specifies the value of the Lenth field.';
                    ApplicationArea = all;
                }
                field("Is Primary"; Rec."Is Primary")
                {
                    ToolTip = 'Specifies the value of the Is Primary field.';
                    ApplicationArea = all;
                }
                field(Remark; Rec.Remark)
                {
                    ToolTip = 'Specifies the value of the Remark field.';
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SetIncluded)
            {
                Caption = 'Set Included';
                ApplicationArea = Basic, Suite;
                Image = Approve;
                ToolTip = 'Executes the Set Included action.';
                trigger OnAction()
                var
                    apiline: Record "API Setup Line";
                begin
                    apiline.reset();
                    apiline.SetRange("Page Name", rec."Page Name");
                    apiline.SetRange("Line Type", rec."Line Type");
                    apiline.SetFilter("Field No.", '<>%1', 0);
                    if apiline.FindFirst() then
                        apiline.ModifyAll(Include, true);
                end;

            }
            action(ClearIncluded)
            {
                Caption = 'Clear Included';
                ApplicationArea = Basic, Suite;
                Image = Reject;
                ToolTip = 'Executes the Clear Included action.';
                trigger OnAction()
                var
                    apiline: Record "API Setup Line";
                begin
                    apiline.reset();
                    apiline.SetRange("Page Name", rec."Page Name");
                    apiline.SetRange("Line Type", rec."Line Type");
                    apiline.SetRange("Is Primary", false);
                    apiline.SetFilter("Field No.", '<>%1', 0);
                    if apiline.FindFirst() then
                        apiline.ModifyAll(Include, false);
                end;

            }
        }
    }
}
