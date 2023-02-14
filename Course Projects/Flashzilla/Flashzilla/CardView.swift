//
//  CardView.swift
//  Flashzilla
//
//  Created by Annalie Kruseman on 1/23/23.
//

import SwiftUI

extension Shape {
    func fill(using offset: CGSize) -> some View {
        if offset.width == 0 {
            return self.fill(.white)
        } else if offset.width < 0 {
            return self.fill(.red)
        } else {
            return self.fill(.green)
        }
    }
}

struct CardView: View {
    let card: Card
    // remove the card
//     var removal: (() -> Void)? = nil
    // remove the card and if the answer is incorrect, return card to the deck
    var removal: ((Bool) -> Void)? = nil
    
    // add feedback through vibration
    @State private var feedback = UINotificationFeedbackGenerator()
    // recognize VoiceOver
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled

    // correct for color disabilities
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    // show the answer when card is tapped
    @State private var isShowingAnswer = false
    // move the card
    @State private var offset = CGSize.zero
    
    var body: some View {
        ZStack {
            // create the card
            RoundedRectangle(cornerRadius: 25, style: .continuous)
            // fill color with opacity
                .fill(
                    // correct for color blindness
                    differentiateWithoutColor ? .white
                    : .white.opacity(1 - Double(abs(offset.width / 50)))
                )
            // color rectangle depending on swipe direction
                .background(
                    differentiateWithoutColor ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(using: offset) // using an extension on Shape
                            // original
//                            offset.width == 0 ? .white
//                            : offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
            VStack {
                // if VoiceOver is enables make it a single text view
                if voiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                    // show answer when true
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        // rotate
        .rotationEffect(.degrees(Double(offset.width / 5)))
        // move
        .offset(x: offset.width * 5, y: 0)
        // fade away when moving further away
        .opacity(2 - Double(abs(offset.width / 50)))
        // tell user that the card is a button
        .accessibilityAddTraits(.isButton)
        // track gesture on the screen and perform action accordingly with if else
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    // get ready to return feedback
                    feedback.prepare()
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        // add vibration feedback
                        if offset.width > 0 {
                            // judge for your self whether haptics are adding value or annoyancy.
                            feedback.notificationOccurred(.success)
                            // do not return card to deck
                            removal?(false)
                        } else {
                            feedback.notificationOccurred(.error)
                            // return card back to deck
                            removal?(true)
                            // move the card to the center (results in messing around with assigning multiple indices to a card, correct for making the Card identifiable)
                            offset = .zero
                        }
                        
                        // remove the card from the deck (regardless correct/incorrect)
                        // removal?()
                    } else {
                        offset = .zero
                    }
                }
        )
        // perform an action on the tap
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        // make the movement when you release the card back to center smoother
        .animation(.spring(), value: offset)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
