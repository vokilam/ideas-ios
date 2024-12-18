//
//  MockData.swift
//  Ideas
//
//  Created by Paul Malikov on 30.11.24.
//

import Foundation

struct MockData {
    static let ideas = [
        Idea(
            title: "Remove background",
            description: "An app that removes background from photo using AI. Background removal is performed locally."
        ),
        Idea(
            title: "Summarize youtube video",
            description: "An app that summarizes youtube video using AI. Youtube API is used to get captions. Then AI summarizes them."
        ),
        Idea(
            title: "Generate image",
            description: "An app that generates image using AI. AI generates image based on prompt. Prompt is provided by user. The app then shows the generated image. User can then save the image. User can then share the image. User can then delete the image. User can then rate the image. User can then comment on the image. User can then like the image."
        ),
        Idea(
            title: "Image upscaling",
            description: "An app that upscapes image using AI. AI upscapes image based on prompt. Prompt is provided by user. The app then shows the upscased image."
        ),
        Idea(
            title: "Image to text",
            description: "An app that converts image to text using AI. AI converts image to text. The app then shows the text."
        ),
        Idea(
            title: "Text to image",
            description: "An app that converts text to image using AI. AI converts text to image. The app then shows the image."
        )
    ]
    
    static let projects = [
        Project(
            name: "My project",
            owner: "userId1",
            ideas: ideas,
            collaborators: nil
        )
    ]
    
    static let sampleProject = projects[0]
    static let sampleIdea = ideas[0]
}
