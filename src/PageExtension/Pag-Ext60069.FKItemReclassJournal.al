pageextension 60069 "FK Item Reclass. Journal" extends "Item Reclass. Journal"
{
    layout
    {
        modify("Document No.")
        {
            trigger OnAssistEdit()
            begin
                if rec.AssistEdit(Xrec) then
                    CurrPage.Update();
            end;
        }
    }
}

